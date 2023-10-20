import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    /// 1.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 창고 데이터
class Model {
  int num;
  Model(this.num);
}

/// 창고 ≒ class(상태와 행위를 가지고 있다)
// 생성 방법 : Provider(상태), StateNotifierProvider(상태 + 메소드)
// Provider -> int num = 1 또는 상태가 2개 이상일 때 클래스;
// StateNotifierProvider -> 클래스 + 메소드
class ViewModel extends StateNotifier<Model?> {
  ViewModel(super.state); // 상태를 관리하는 StateNotifer에게 전달 -> null 관리함

  /// 데이터의 초기화 코드 -> 통신 코드 들어감
  void init() {
    // 원래 여기 통신 코드 들어감
    state = Model(1);
  }

  /// 창고 데이터에 접근하여 상태를 변경하는 방법
  void change() {
    state = Model(2);
  }
}

/// 창고 관리자 -> 처음에 null였다가, 통신이 끝나면 화면이 다시 그려진다.
final numProvider = StateNotifierProvider<ViewModel, Model?>((ref) {
  return ViewModel(null)..init(); // 통신 코드 날리기
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MyText1(),
              MyText2(),
              MyText3(),
              MyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends ConsumerWidget {
  const MyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          ref.read(numProvider.notifier).change();
          // 창고 바로 접근(원하는 게 있으면 창고로 바로 접근해야 한다)
          // 접근 후 바로 Change
        },
        child: Text("상태 변경"));
  }
}

class MyText3 extends StatelessWidget {
  const MyText3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("5", style: TextStyle(fontSize: 30));
  }
}

/// 수신하고 싶은 클래스로 가서, 구독하고 싶으면 -> 컨슈머가 된다.
/// StatelessWidget -> ConsumerWidget

class MyText2 extends ConsumerWidget {
  const MyText2({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ref -> 창고관리자에게 접근하는 참고 변수
    Model? model = ref.watch(numProvider);
    // null 일 수 있기 때문에 "?"를 붙여야 한다.

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}

class MyText1 extends ConsumerWidget {
  const MyText1({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Model? model = ref.watch(numProvider);
    // null 일 수 있기 때문에 "?"를 붙여야 한다.

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}
