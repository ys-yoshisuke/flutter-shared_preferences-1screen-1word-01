// shared_preferences の使用例
// このコードでは、shared_preferencesパッケージを利用して、テキスト入力欄に入力された文字列をローカルストレージに保存し、
//アプリ再起動時に保存された文字列を読み込んで表示する機能を実装します。
// 実装内容：
//１．画面には、テキスト入力欄⓵があります。
//２．テキスト入力欄⓶には、文字列を入力できます。
//３．画面には、登録用ボタン⓷があります。
//４．画面上の登録用ボタン⓷の下側には、文字列表示欄⓸があります。
//４．登録用ボタン⓷を押すと、テキスト入力欄⓶の内容は、文字列表示欄⓸に表示されます。
//５．上記１～４を実行後、アプリを再起動しても、上記４で表示された、文字列表示欄⓸の文字列は、再度表示されています。
//６．スマフォを再起動後、アプリを再度起動すると、上記４で表示された、文字列表示欄⓸の文字列は、再度表示されています。

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyDataLoadSaveApp());
}

class MyDataLoadSaveApp extends StatefulWidget {
  const MyDataLoadSaveApp({super.key});

  @override
  State<MyDataLoadSaveApp> createState() => _MyDataLoadSaveAppState();
}

class _MyDataLoadSaveAppState extends State<MyDataLoadSaveApp> {
  // TextEditingControllerはテキストフィールド（TextFieldやTextFormFieldなど）を制御するために使用されるクラスです。
  //このコントローラーを使用することで、テキストフィールドの現在のテキスト値を取得したり、
  //プログラムによってテキスト値を変更したりすることができます。
  // このコード行では、_controllerという名前のTextEditingControllerのインスタンスを作成し、finalキーワードを用いて宣言しています。
  //finalキーワードは、変数が一度値を割り当てられた後は変更できないことをDartに伝えます。
  //つまり、_controllerには他のTextEditingControllerインスタンスを再割り当てすることはできませんが、
  //_controllerを介してテキストフィールドの内容を読み取ったり変更したりすることは可能です。
  // _controllerをテキストフィールドウィジェットのcontrollerプロパティに割り当てることで、
  //そのテキストフィールドの入力値の監視や操作を行うことができます。
  //例えば、ユーザーがフォームに入力したテキストを取得するには、_controller.textを使用します。
  final TextEditingController _controller = TextEditingController();

  String _displayedText = '';

  // 入力データ操作
  // 初期化処理
  @override
  void initState() {
    super.initState();
    _loadDisplayedText();
  }

  // データ呼出(SharedPreferencesからのデータ読込)関数：
  // アプリケーションが起動するたび（例えばinitState()メソッド内から）に呼び出され、
  //以前のセッションでユーザーが入力した文字列をロードし、表示するために使用されます。
  _loadDisplayedText() async {
    // SharedPreferencesのインスタンスを非同期に取得します。
    //awaitキーワードは、非同期処理の結果が利用可能になるまで実行を一時停止します。
    //これにより、prefs変数にSharedPreferencesのインスタンスが格納され、
    //以降のコードでこのインスタンスを通じて保存されたデータにアクセスできるようになります。
    final prefs = await SharedPreferences.getInstance();
    // ウィジット状態更新処理：
    setState(() {
      // setState(() { ... });は、ウィジェットの状態を更新するためのFlutterの関数です。
      //この関数内で行われる変更は、UIの再描画を引き起こします。

      // SharedPreferencesから'displayedText'キーに対応する文字列を取得します。
      //もし該当するキーが存在しない場合（つまり、まだ何も保存されていない場合）、
      //??演算子によりデフォルト値として空文字列''が割り当てられます。
      //これにより、アプリケーションが初めて起動されたときでも、エラーが発生することなく、安全に文字列を扱うことができます。
      _displayedText = prefs.getString('displayedText') ?? '';
    });
  }

  // 入力データ保存(SharedPreferencesへの保存)関数：
  // Flutterアプリケーションでユーザーが入力した文字列をSharedPreferencesを用いてローカルに保存するための関数です。
  // _saveDisplayedText({required String text})は、非同期関数（asyncを使用）で、textという名前の引数を取ります。
  //この引数はrequiredキーワードによって必須であることが指定されており、String型である必要があります。
  //関数が呼び出される際には、このtext引数に保存したい文字列を指定します。
  _saveDisplayedText({required text}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayedText', text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Column(
          children: <Widget>[
            //　１．テキスト入力欄⓵
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                // TextFieldウィジェットのcontrollerプロパティに_controllerを割り当てることで、
                //このテキストフィールドの入力値を制御しています。
                //ユーザーがテキストフィールドに何かを入力すると、その値は自動的に_controllerによって追跡され、
                //_controller.textを通じてアクセスできるようになります。
                controller: _controller,

                decoration: const InputDecoration(
                  labelText: 'Enter text here',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _displayedText = _controller.text;
                  _saveDisplayedText(text: _displayedText);
                });
              },
              child: const Text('Submit'),
            ),
            // ２．文字列表示欄⓶
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _displayedText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 備考：
//（１）children: <Widget>[]の部分は、FlutterでUIを構築する際に使用される構文の一部です。この構文は、特にColumn、Row、ListViewなどのウィジェットが、複数の子ウィジェットを持つことができる場合に使われます。ここで<Widget>は、このリストがWidgetオブジェクトのリストであることをDartに伝えるジェネリック型アノテーションです。
// <Widget>の意味
// <Widget>は、このリストがWidgetクラスのインスタンス、またはそのサブクラスのインスタンスのみを含むことができることを示します。これにより、Dartの型安全性を高め、開発者が非ウィジェット型のオブジェクトを誤ってchildrenリストに追加することを防ぎます。
// <Widget>を書かない場合
// Dartは型推論が可能な言語なので、特にリストが空で始まる場合や、リスト内の全ての要素が明らかにWidget型である場合（コンパイラが容易に推論できる場合）は、<Widget>を省略してもコードは正しく動作します。しかし、型を明示的に指定することは、コードの可読性と保守性を高めるために推奨されます。
// <Widget>を省略した場合、コンパイラはリスト内の要素からリストの型を推論します。全ての要素がWidgetのサブクラスのインスタンスであれば問題ありませんが、もし異なる型のオブジェクトが含まれていた場合、型安全性の問題が発生し、コンパイル時または実行時にエラーが生じる可能性があります。
// 総じて、<Widget>のようなジェネリック型アノテーションは、型の安全性を確保し、コードの意図を明確に伝えるために重要です。特に複雑なアプリケーションや、チームでの開発では、型を明示的に指定することで、エラーの発生を減らし、コードの品質を向上させることができます。







