Berikut dokumentasi API project kamu (sesuai kode saat ini) + cara testing di Postman.

## Base Config

- Base URL: `http://localhost:3000/api`
- Auth type: `Bearer JWT`
- Header untuk endpoint protected:
  - `Authorization: Bearer <accessToken>`
  - `Content-Type: application/json`

## Auth Requirement per Endpoint

- `Public`: tidak perlu token.
- `Bearer user/admin`: token user biasa atau admin bisa.
- `Bearer admin`: hanya token dengan role `admin`.

## Persiapan Sebelum Test

1. Pastikan `.env` sudah benar:

```env
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=topung_db

JWT_SECRET=your-real-secret
JWT_EXPIRES_IN=1d
```

2. Pastikan tabel PostgreSQL sudah dibuat di `topung_db`.
3. Jalankan backend:

```bash
npm run start:dev
```

---

## Format Pagination (dipakai di 4 endpoint)

```json
{
  "data": {
    "filter": [{ "field": "string", "operator": "string", "value": "string" }],
    "sort": [{ "field": "string", "direction": "asc" }],
    "search": "string",
    "expression": "string",
    "pagination": {
      "page": 1,
      "pageSize": 10
    }
  },
  "options": {
    "showError": true,
    "rollbackOnFailure": true,
    "showInfo": true
  }
}
```

---

## 1) Auth

### `POST /auth/register`

Auth: `Public`
Payload:

```json
{
  "name": "User Satu",
  "email": "user1@mail.com",
  "password": "password123"
}
```

### `POST /auth/login`

Auth: `Public`
Payload:

```json
{
  "email": "user1@mail.com",
  "password": "password123"
}
```

Response utama:

- `data.accessToken`
- `data.user.role` (`user` atau `admin`)

Catatan role admin:

- Role admin sekarang diambil dari kolom `users.role` di database.

---

## 2) Users

### `POST /users`

Auth: `Public`
Payload:

```json
{
  "name": "User Dua",
  "email": "user2@mail.com",
  "password": "password123"
}
```

### `GET /users`

Auth: `Public`

### `GET /users/me`

Auth: `Bearer user/admin`

---

## 3) Categories

### `POST /categories/pagination`

Auth: `Bearer user/admin`
Payload contoh:

```json
{
  "data": {
    "filter": [],
    "sort": [{ "field": "name", "direction": "asc" }],
    "search": "",
    "expression": "",
    "pagination": { "page": 1, "pageSize": 10 }
  },
  "options": {
    "showError": true,
    "rollbackOnFailure": true,
    "showInfo": true
  }
}
```

---

## 4) Materials

### `POST /materials/pagination`

Auth: `Bearer user/admin`

- Bisa filter `category_id` di `data.filter`
  Contoh:

```json
{
  "data": {
    "filter": [{ "field": "category_id", "operator": "eq", "value": "1" }],
    "sort": [{ "field": "created_at", "direction": "desc" }],
    "search": "",
    "expression": "",
    "pagination": { "page": 1, "pageSize": 10 }
  },
  "options": {
    "showError": true,
    "rollbackOnFailure": true,
    "showInfo": true
  }
}
```

### `GET /materials/:id`

Auth: `Bearer user/admin`

### `POST /materials/:id/comments/pagination`

Auth: `Bearer user/admin`

- Payload: format pagination standar

### `POST /materials/:id/comments`

Auth: `Bearer user/admin`
Payload:

```json
{
  "content": "Komentar saya",
  "parentCommentId": null
}
```

### `POST /materials/:id/interactions`

Auth: `Bearer user/admin`
Payload:

```json
{
  "interactionType": "like"
}
```

Contoh nilai: `like`, `dislike`, `bookmark`, `view` (ikuti aturan DB kamu)

### `PUT /materials/:id/status`

Auth: `Bearer user/admin`
Payload:

```json
{
  "status": "in_progress"
}
```

Contoh nilai: `not_started`, `in_progress`, `completed`

---

## 5) Chatbot (Multi-turn & Chunked RAG)

Sistem chatbot telah di-upgrade menggunakan arsitektur **Chunked RAG** (Retrieval-Augmented Generation).
**Mekanisme Sistem Baru:**

1. Saat materi dibuat/diupdate, konten dipotong menjadi _chunks_ (max 400 token, overlap 100 token) dan disimpan ke tabel `chatbot_knowledge`.
2. Saat user bertanya, sistem men-generate _embedding_ dari pertanyaan dan mencari _top 10 chunks_ yang paling relevan (vector search).
3. Chunks yang ditemukan digabung menjadi konteks bagi LLM untuk menjawab.
4. Sistem melacak `material_id` dari chunks tersebut dan mengembalikannya sebagai `sources` (sumber referensi yang akurat sesuai bagian teks yang benar-benar dipakai).

### `POST /chatbot/ask`

Auth: `Bearer user/admin`
Payload:

```json
{
  "question": "Bagaimana cara mengatasi nyeri punggung?",
  "conversationId": "uuid-atau-id-sesi-unik-anda"
}
```

- `conversationId`: (Opsional) Gunakan ID yang sama untuk melanjutkan percakapan agar AI ingat konteks sebelumnya (mengambil 3 turn percakapan terakhir). Jika baru, sistem akan memulai sesi baru.

**Response API:**

```json
{
  "message": "Success",
  "data": {
    "id": "1",
    "userId": "12",
    "question": "Bagaimana cara mengatasi nyeri punggung?",
    "answer": "Berdasarkan materi, Anda bisa...",
    "conversationId": "uuid-atau-id-sesi-unik-anda",
    "sources": [
      {
        "id": "4",
        "title": "Materi Fisioterapi Punggung",
        "videoUrl": "...",
        "imageUrl": "..."
      }
    ],
    "images": [
      {
        "imageUrl": "https://res.cloudinary.com/dcc9jmwoh/image/upload/v1779292637/diabetes_dlorzh.png",
        "imageCaption": "Ilustrasi titik tekan di punggung"
      }
    ],
    "timestamp": "2026-05-01T12:00:00Z"
  }
}
```

### `POST /chatbot/history/pagination`

Auth: `Bearer user/admin`

- Payload: format pagination standar
- **Response**: Mengembalikan daftar sesi percakapan (unik per `conversationId`). Judul diambil dari pertanyaan pertama setiap sesi.

Contoh Response API:

```json
{
  "message": "Success",
  "items": [
    {
      "conversationId": "uuid-atau-id-sesi-unik-anda",
      "title": "Bagaimana cara mengatasi nyeri punggung?",
      "lastActivity": "2026-05-01T12:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

### `POST /chatbot/history/pagination/:conversationId`

Auth: `Bearer user/admin`

- Payload: format pagination standar
- **Response**: Mengembalikan seluruh riwayat tanya-jawab di dalam sesi tersebut secara kronologis.

Contoh Response API:

```json
{
  "message": "Success",
  "items": [
    {
      "id": "1",
      "userId": "12",
      "question": "Bagaimana cara mengatasi nyeri punggung?",
      "answer": "Berdasarkan materi, Anda bisa...",
      "conversationId": "uuid-atau-id-sesi-unik-anda",
      "sources": [
        {
          "id": "4",
          "title": "Materi Fisioterapi Punggung",
          "videoUrl": "...",
          "imageUrl": "..."
        }
      ],
      "images": [
        {
          "imageUrl": "https://res.cloudinary.com/dcc9jmwoh/image/upload/v1779292637/diabetes_dlorzh.png",
          "imageCaption": "30. Diabetes"
        }
      ],
      "timestamp": "2026-05-01T12:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

---

## 6) Admin (JWT + role admin)

Semua endpoint ini butuh token admin.

### Categories Admin

- `POST /admin/categories`
  - Auth: `Bearer admin`

```json
{
  "name": "Penyakit Saraf",
  "description": "Materi saraf",
  "imageUrl": "https://example.com/saraf.png"
}
```

- `PUT /admin/categories/:id`
  - Auth: `Bearer admin`

```json
{
  "name": "Penyakit Saraf Update",
  "description": "Update deskripsi",
  "imageUrl": "https://example.com/saraf2.png"
}
```

- `DELETE /admin/categories/:id`
  - Auth: `Bearer admin`
  - **Catatan (Hard Delete)**: Menggunakan aturan **`ON DELETE RESTRICT`** dari tabel `materials`. Penghapusan akan gagal (error _Constraint Violation_) jika masih ada material yang terasosiasi dengan kategori ini. Pastikan Anda menghapus seluruh material di dalamnya terlebih dahulu.

### Materials Admin

- `POST /admin/materials`
  - Auth: `Bearer admin`

```json
{
  "categoryId": "1",
  "title": "Materi Admin",
  "videoUrl": "https://youtube.com/watch?v=abc",
  "textContent": "Isi materi",
  "imageUrl": "https://example.com/materi.png"
}
```

- `PUT /admin/materials/:id`
  - Auth: `Bearer admin`

```json
{
  "categoryId": "1",
  "title": "Materi Admin Update",
  "videoUrl": "https://youtube.com/watch?v=def",
  "textContent": "Isi update",
  "imageUrl": "https://example.com/materi-update.png"
}
```

- `DELETE /admin/materials/:id`
  - Auth: `Bearer admin`
  - **Catatan (Hard Delete)**: Menggunakan aturan **`ON DELETE CASCADE`**. Saat material ini dihapus, semua data yang terkait (termasuk _comments_, _interactions_, dan _user_material_status_) akan otomatis terhapus dari database.

### Vector Documents (stub)

- `POST /admin/vector-documents`
  - Auth: `Bearer admin`

```json
{
  "title": "Dokumen Sumber",
  "sourceUrl": "https://example.com/doc.pdf"
}
```

### User Role Admin

- `PUT /admin/users/:id/role`
  - Auth: `Bearer admin`

```json
{
  "role": "admin"
}
```

Nilai `role` yang valid: `admin`, `user`.

---

## Urutan Testing Postman (Disarankan)

1. Register user biasa -> login -> simpan token user.
2. Hit `GET /users/me` (validasi token).
3. Test endpoint user:

- `/categories/pagination`
- `/materials/pagination`
- `/materials/:id`
- comment/interactions/status

4. Ubah role user jadi admin lewat endpoint `PUT /admin/users/:id/role` (dengan token admin awal/seed), lalu login ulang untuk dapat token role admin.
5. Test endpoint admin CRUD.
6. Test negatif:

- akses `/admin/*` pakai token user biasa => harus `403`.

Kalau kamu mau, saya bisa lanjutkan bikin **Postman Collection v2.1 JSON** siap import (beserta environment variable `baseUrl`, `userToken`, `adminToken`).
