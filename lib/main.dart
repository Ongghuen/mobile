import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobile/logic/data/bloc/auth/auth_bloc.dart';
import 'package:mobile/logic/data/bloc/detail_transaction/detail_transaction_bloc.dart';
import 'package:mobile/logic/data/bloc/product/product_bloc.dart';
import 'package:mobile/logic/data/bloc/transaction/transaction_bloc.dart';
import 'package:mobile/logic/data/bloc/transaction_custom/transaction_custom_bloc.dart';
import 'package:mobile/logic/data/bloc/wishlist/wishlist_bloc.dart';
import 'package:mobile/presentation/router/app_router.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // hydrated bloc buat ngisi bloc kek localstorage
  // hive juga sama kek gitu
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Hive.initFlutter();
  await Hive.openBox('utils');

  // preferensi system color
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey[50], // navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
  ));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(),
      ),
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(),
      ),
      BlocProvider<WishlistBloc>(
        create: (_) => WishlistBloc(),
      ),
      BlocProvider<TransactionBloc>(
        create: (_) => TransactionBloc(),
      ),
      BlocProvider<DetailTransactionBloc>(
        create: (_) => DetailTransactionBloc(),
      ),
      BlocProvider<TransactionCustomBloc>(
        create: (_) => TransactionCustomBloc(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // check di AppRouter() "/" -- itu initial routenya kemana
      onGenerateRoute: AppRouter().onGenerateRoute,
    ),
  ));
}
