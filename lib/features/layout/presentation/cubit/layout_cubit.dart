import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_tab.dart';

class LayoutCubit extends Cubit<LayoutTab> {
  LayoutCubit() : super(LayoutTab.home);

  void goTo(LayoutTab tab) => emit(tab);
}
