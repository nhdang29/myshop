import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myshop/ui/screens.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child){
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange),
            ),
            debugShowCheckedModeBanner: false,

            home: authManager.isAuth
                ? const ProductsOverviewScreen() : FutureBuilder(
              future: authManager.tryAutoLogin(),
              builder: (ctx, snapshot){
                return snapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const AuthScreen();
              },
            ),

            routes: {
              CartScreen.routeName : (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName){
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                    builder: (ctx){
                      return ProductDetailScreen(
                        ctx.read<ProductsManager>().findById(productId)!,
                      );
                    }
                );
              }

              if(settings.name == EditProductScreen.routeName){
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                    builder: (ctx){
                      return EditProductScreen(
                          productId != null
                              ? ctx.read<ProductsManager>().findById(productId)
                              : null
                      );
                    }
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
