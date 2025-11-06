import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon/bloc/pokemon_bloc.dart';
import 'package:pokemon/config/app_router.dart';
import 'package:pokemon/config/search_cubit.dart';
import 'package:pokemon/cubit/filter_cubit.dart';
import 'package:pokemon/cubit/pokemon_selection_cubit.dart';
import 'package:pokemon/cubit/type_cubit.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PokemonBloc()),
            BlocProvider(create: (context) => SearchCubit()),
            BlocProvider(create: (context) => TypeCubit()..fetchTypes()),
            BlocProvider(create: (context) => FilterCubit()),
            BlocProvider(create: (context) => PokemonSelectionCubit()),
          ],
          child: MaterialApp.router(
            title: 'Pokédex',
            theme: ThemeData(
              primarySwatch: Colors.red,
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
