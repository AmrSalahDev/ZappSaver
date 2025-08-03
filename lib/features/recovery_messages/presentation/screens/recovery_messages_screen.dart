import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/features/recovery_messages/data/models/item_model.dart';
import 'package:flutter_status_up/features/widgets/custom_app_bar.dart';
import 'package:flutter_status_up/features/widgets/custom_card.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class RecoveryMessages extends StatelessWidget {
  const RecoveryMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      navigationBarColor: Colors.white,
      navigationBarIconBrightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                CustomAppBar(title: S.of(context).recoveryMessages),
                SizedBox(height: context.screenHeight * 0.04),
                Expanded(child: CustomTabBarView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.black54,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: [
              Tab(
                child: Text(
                  S.of(context).whatsapp,
                  style: TextStyle(fontSize: context.textScaler.scale(16)),
                ),
              ),
              Tab(
                child: Text(
                  S.of(context).whatsappBusiness,
                  style: TextStyle(fontSize: context.textScaler.scale(16)),
                ),
              ),
            ],
          ),
          SizedBox(height: context.screenHeight * 0.02),
          Expanded(
            child: TabBarView(children: [WhatsappTab(), WhatsappBusinessTab()]),
          ),
        ],
      ),
    );
  }
}

class WhatsappBusinessTab extends StatelessWidget {
  const WhatsappBusinessTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ItemModel.items;
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) => CustomCard(
              iconPath: items[index].iconPath,
              title: items[index].title,
            ),
          ),
        ),
      ],
    );
  }
}

class WhatsappTab extends StatelessWidget {
  const WhatsappTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ItemModel.items;
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) => CustomCard(
              iconPath: items[index].iconPath,
              title: items[index].title,
              onTap: () {
                if (items[index] == items[0]) {
                  context.push(AppRouter.recoveryChat);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
