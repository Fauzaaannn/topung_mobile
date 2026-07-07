import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/domain/usecases/illness_category_usecases/illness_category_usecase.dart';
import 'package:topung_mobile/presentation/bloc/illness_category_bloc/illness_category_bloc.dart';
import 'package:topung_mobile/presentation/widgets/cards/illness_category_card.dart';

@RoutePage()
class IllnessCategoryPage extends StatelessWidget {
  const IllnessCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IllnessCategoryBloc(
        illnessCategoryUsecase: serviceLocator<IllnessCategoryUsecase>(),
      )..add(IllnessCategoryFetched()),
      child: const _IllnessCategoryView(),
    );
  }
}

class _IllnessCategoryView extends StatefulWidget {
  const _IllnessCategoryView();

  @override
  State<_IllnessCategoryView> createState() => _IllnessCategoryViewState();
}

class _IllnessCategoryViewState extends State<_IllnessCategoryView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      context.read<IllnessCategoryBloc>().add(
        IllnessCategoryFetched(search: query, page: 1),
      );
    });
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<IllnessCategoryBloc>().state;
      if (state is IllnessCategorySuccess &&
          !state.hasReachedMax &&
          !state.isFetchingMore) {
        final nextPage = state.data.pagination.page + 1;
        context.read<IllnessCategoryBloc>().add(
          IllnessCategoryFetched(page: nextPage, search: _searchQuery),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        title: Text(
          'Kategori Penyakit',
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.white,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                hintStyle: TextStyle(
                  color: ColorConstant.greyDark,
                  fontSize: FontConstant.fontSize14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: ColorConstant.greyDark,
                ),
                filled: true,
                fillColor: ColorConstant.greyLight.withOpacity(0.3),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<IllnessCategoryBloc, IllnessCategoryState>(
              builder: (context, state) {
                if (state is IllnessCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is IllnessCategoryFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstant.black,
                            fontFamily: FontConstant.robotoFontFamily,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<IllnessCategoryBloc>()
                              .add(IllnessCategoryFetched()),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is IllnessCategorySuccess) {
                  if (state.data.items.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? "Tidak ada kategori yang ditemukan dari '$_searchQuery'"
                            : 'Belum ada kategori penyakit',
                        style: TextStyle(
                          fontSize: FontConstant.fontSize14,
                          color: ColorConstant.grey,
                          fontFamily: FontConstant.robotoFontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  final items = List.of(state.data.items)
                    ..sort((a, b) {
                      final idA = int.tryParse(a.id);
                      final idB = int.tryParse(b.id);
                      if (idA != null && idB != null) {
                        return idA.compareTo(idB);
                      }
                      return a.id.compareTo(b.id);
                    });
                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: items.length + (state.isFetchingMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        Divider(color: ColorConstant.greyLight, height: 1),
                    itemBuilder: (context, index) {
                      if (index >= items.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final category = items[index];
                      return IllnessCategoryCard(
                        title: category.name,
                        description: category.description,
                        imageUrl: category.imageUrl.isNotEmpty
                            ? category.imageUrl
                            : null,
                        onTap: () {
                          context.router.push(
                            IllnessTypeRoute(
                              categoryId: category.id,
                              categoryTitle: category.name,
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
