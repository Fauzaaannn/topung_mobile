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

class _IllnessCategoryView extends StatelessWidget {
  const _IllnessCategoryView();

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
      body: BlocBuilder<IllnessCategoryBloc, IllnessCategoryState>(
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
                    onPressed: () => context.read<IllnessCategoryBloc>().add(
                      IllnessCategoryFetched(),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is IllnessCategorySuccess) {
            final items = state.data.items;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  Divider(color: ColorConstant.greyLight, height: 1),
              itemBuilder: (context, index) {
                final category = items[index];
                return IllnessCategoryCard(
                  title: category.name,
                  description: category.description,
                  imageUrl: category.imageUrl.isNotEmpty
                      ? category.imageUrl
                      : null,
                  onTap: () {
                    context.router.push(
                      IllnessTypeRoute(categoryTitle: category.name),
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
