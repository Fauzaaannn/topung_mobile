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
    return BlocProvider(
      create: (_) => IllnessTypeBloc(
        illnessTypeUsecase: serviceLocator<IllnessTypeUsecase>(),
      )..add(IllnessTypeFetched(categoryId: categoryId)),
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
      body: BlocBuilder<IllnessTypeBloc, IllnessTypeState>(
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
                    onPressed: () => context.read<IllnessTypeBloc>().add(
                      IllnessTypeFetched(categoryId: widget.categoryId),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is IllnessTypeSuccess) {
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
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return IllnessTypeCard(
                  title: item.title,
                  description: item.textContent,
                  imageUrl: item.imageUrl.isNotEmpty ? item.imageUrl : null,
                  status: _bookmarkedIds.contains(item.id)
                      ? IllnessTypeCardStatus.bookmarked
                      : IllnessTypeCardStatus.none,
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
    );
  }
}
