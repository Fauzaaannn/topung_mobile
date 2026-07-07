import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/domain/usecases/illness_type_usecases/illness_type_usecase.dart';
import 'package:topung_mobile/presentation/bloc/illness_type_bloc/illness_type_bloc.dart';
import 'package:topung_mobile/presentation/widgets/cards/illness_type_card.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_bloc.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_event.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_state.dart';
import 'package:topung_mobile/domain/usecases/interaction_usecases/interaction_usecase.dart';

@RoutePage()
class IllnessTypePage extends StatelessWidget {
  const IllnessTypePage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  final String categoryId;
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => IllnessTypeBloc(
            illnessTypeUsecase: serviceLocator<IllnessTypeUsecase>(),
          )..add(IllnessTypeFetched(categoryId: categoryId)),
        ),
        BlocProvider(
          create: (_) => InteractionBloc(serviceLocator<InteractionUsecase>()),
        ),
      ],
      child: _IllnessTypeView(
        categoryId: categoryId,
        categoryTitle: categoryTitle,
      ),
    );
  }
}

class _IllnessTypeView extends StatefulWidget {
  const _IllnessTypeView({
    required this.categoryId,
    required this.categoryTitle,
  });

  final String categoryId;
  final String categoryTitle;

  @override
  State<_IllnessTypeView> createState() => _IllnessTypeViewState();
}

class _IllnessTypeViewState extends State<_IllnessTypeView> {
  final Set<String> _bookmarkedIds = {};
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  bool _isFetchingMore = false;

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

  void _onScroll() {
    if (_isBottom && !_isFetchingMore) {
      final state = context.read<IllnessTypeBloc>().state;
      if (state is IllnessTypeSuccess) {
        if (state.data.pagination.page < state.data.pagination.totalPages) {
          setState(() {
            _isFetchingMore = true;
          });
          final nextPage = state.data.pagination.page + 1;
          context.read<IllnessTypeBloc>().add(
            IllnessTypeFetched(
              categoryId: widget.categoryId,
              page: nextPage,
              search: _searchQuery,
            ),
          );
        }
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      context.read<IllnessTypeBloc>().add(
        IllnessTypeFetched(
          categoryId: widget.categoryId,
          search: query,
          page: 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          widget.categoryTitle,
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.white,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<IllnessTypeBloc, IllnessTypeState>(
            listener: (context, state) {
              if (state is IllnessTypeSuccess) {
                setState(() {
                  for (final item in state.data.items) {
                    if (item.isBookmarked) {
                      _bookmarkedIds.add(item.id);
                    }
                  }
                });
              }
            },
          ),
          BlocListener<InteractionBloc, InteractionState>(
            listener: (context, state) {
              if (state is InteractionActionError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari penyakit...',
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
              child: BlocConsumer<IllnessTypeBloc, IllnessTypeState>(
                listener: (context, state) {
                  if (state is IllnessTypeSuccess ||
                      state is IllnessTypeFailure) {
                    setState(() {
                      _isFetchingMore = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is IllnessTypeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is IllnessTypeFailure) {
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
                            onPressed: () =>
                                context.read<IllnessTypeBloc>().add(
                                  IllnessTypeFetched(
                                    categoryId: widget.categoryId,
                                  ),
                                ),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is IllnessTypeSuccess) {
                    if (state.data.items.isEmpty) {
                      return Center(
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? "Tidak ada penyakit yang ditemukan dari '$_searchQuery'"
                              : 'Belum ada data penyakit',
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
                      itemCount:
                          items.length +
                          (_isFetchingMore ||
                                  state.data.pagination.page <
                                      state.data.pagination.totalPages
                              ? 1
                              : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final item = items[index];
                        return IllnessTypeCard(
                          title: item.title,
                          description: item.textContent,
                          imageUrl: item.imageUrl.isNotEmpty
                              ? item.imageUrl
                              : null,
                          status: _bookmarkedIds.contains(item.id)
                              ? IllnessTypeCardStatus.bookmarked
                              : IllnessTypeCardStatus.none,
                          onStatusTap: () {
                            setState(() {
                              if (_bookmarkedIds.contains(item.id)) {
                                _bookmarkedIds.remove(item.id);
                              } else {
                                _bookmarkedIds.add(item.id);
                              }
                            });
                            context.read<InteractionBloc>().add(
                              PostInteractionEvent(
                                materialId: item.id,
                                interactionType: 'bookmark',
                              ),
                            );
                          },
                          onTap: () {
                            context.router.push(
                              IllnessMaterialRoute(materialId: item.id),
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
      ),
    );
  }
}
