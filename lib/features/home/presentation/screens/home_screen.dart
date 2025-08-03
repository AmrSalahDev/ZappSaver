import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/application/cubits/banner_ad_cubit.dart';
import 'package:flutter_status_up/application/cubits/rewarded_ad_cubit.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/constants/app_images.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/utils/permission_utils.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BannerAdCubit _bannerAdCubit;
  late final RewardedAdCubit _rewardedAdCubit;
  late final AdvancedDrawerController _advancedDrawerController;

  void checkPermission() async {
    await PermissionUtils.notificationPermissionStatus(
      onEnabled: () {
        debugPrint("Notification permission enabled");
      },
      onDisabled: () {
        PermissionUtils.requestNotificationPermission();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    _bannerAdCubit = getIt<BannerAdCubit>();
    _rewardedAdCubit = getIt<RewardedAdCubit>();
    _advancedDrawerController = AdvancedDrawerController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAdCubit.loadBannerAd(context);
    _rewardedAdCubit.loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAdCubit.dispose();
    _rewardedAdCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light,
      navigationBarColor: Colors.white,
      navigationBarIconBrightness: Brightness.dark,
      child: CustomAppDrawer(
        advancedDrawerController: _advancedDrawerController,
        child: Scaffold(
          bottomNavigationBar: BlocBuilder<BannerAdCubit, BannerAd?>(
            bloc: _bannerAdCubit,
            builder: (context, ad) {
              if (ad == null) return const SizedBox.shrink();
              return SizedBox(
                width: ad.size.width.toDouble(),
                height: ad.size.height.toDouble(),
                child: AdWidget(ad: ad),
              );
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildHeader(context),
                      Positioned(
                        top:
                            context.screenHeight * 0.2 -
                            50, // Half into the header
                        left: 0,
                        right: 0,
                        child: _buildCardSection(context),
                      ),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                        title: S.of(context).directChat,
                        iconPath: AppImages.send,
                      ),
                      CustomCard(
                        title: S.of(context).savedFiles,
                        iconPath: AppImages.folder,
                      ),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                        title: S.of(context).whatsappWeb,
                        iconPath: AppImages.whatsappWeb,
                      ),
                      CustomCard(
                        title: S.of(context).recoverDeletedMessages,
                        iconPath: AppImages.messages,
                        onTap: () => context.push(AppRouter.recoveryMessages),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: context.screenHeight * 0.2,
        width: double.infinity,
        color: AppColors.primaryColor,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            S.of(context).appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.textScaler.scale(30),
              letterSpacing: !context.isArabic ? 1.5 : 0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            S.of(context).subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.textScaler.scale(16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
            icon: Icon(Icons.menu_outlined, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: context.screenHeight * 0.2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _rewardedAdCubit.showIfReady(
                onRewardEarned: () {
                  context.push(AppRouter.status, extra: true);
                },
                elseDoThis: () {
                  context.push(AppRouter.status, extra: true);
                },
              );
            },
            child: _buildCard(
              context,
              AppImages.whatsapp,
              S.of(context).whatsapp,
            ),
          ),
          _buildCard(
            context,
            AppImages.whatsappBusiness,
            S.of(context).whatsappBusiness,
          ),
          //_buildCard(context, AppImages.whatsappWeb, S.of(context).whatsappWeb),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String iconPath, String title) {
    return Container(
      width: context.screenWidth * 0.4,
      height: context.screenHeight * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: constraints.maxHeight * 0.4,
              width: constraints.maxHeight * 0.4,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.textScaler.scale(12),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenWidth * 0.4,
        height: context.screenHeight * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                height: context.screenHeight * 0.05,
                width: context.screenHeight * 0.05,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: context.textScaler.scale(16),

                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppDrawer extends StatelessWidget {
  final Widget child;
  final AdvancedDrawerController advancedDrawerController;
  const CustomAppDrawer({
    super.key,
    required this.child,
    required this.advancedDrawerController,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.primaryColor),
      ),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 24.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      drawer: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: context.screenHeight * 0.03),
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(top: 24.0, bottom: 20.0),
                  child: Image.asset(AppImages.appIcon),
                ),
                Text(
                  S.of(context).appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.textScaler.scale(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.01),
                Text(
                  S.of(context).subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.textScaler.scale(14),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.03),
                Divider(color: Colors.white54),
                ListTile(
                  onTap: () {
                    context.push(AppRouter.selectLang, extra: true);
                  },
                  leading: Icon(Icons.language_outlined),
                  title: Text(S.of(context).language),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings_outlined),
                  title: Text(S.of(context).settings),
                ),
                Divider(color: Colors.white54),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.share_outlined),
                  title: Text(S.of(context).shareApp),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite_border_outlined),
                  title: Text(S.of(context).rateUs),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.info_outlined),
                  title: Text(S.of(context).about),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
