import 'package:crud_riverpord/riverpord/riverpord.dart';
import 'package:crud_riverpord/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      home: MyApp(),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  String title = "";
  String description = "CRUD Operations Using Riverpord";
  TextEditingController _contTitle = TextEditingController();
  TextEditingController _contDescription = TextEditingController();

  clearFn() {
    _contTitle.clear();
    _contDescription.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Operations Using Riverpord'),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            var data = ref.watch(todoData);
            return data.isNotEmpty?ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return ContainerWidget(
                    title: user.title.toString(),
                    description: user.description.toString());
              },
            ):Center(
              child: Text("No Todo tasks",style: Theme.of(context).textTheme.headlineMedium,),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheetAdd(context, ref);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Function to show the custom height bottom sheet
  void _showBottomSheetAdd(BuildContext context, WidgetRef ref,) {
    TextEditingController _contTitle = TextEditingController();
    TextEditingController _contDescription = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 600.0, // Set your desired height here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Let's create",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              textFormWidget(_contTitle, false, "Enter Title"),
              const SizedBox(height: 16.0),
              textFormWidget(_contDescription, true, "Enter Description"),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  if (_contTitle.text.length > 0 &&
                      _contDescription.text.length > 0) {
                    // Check if it's an update or add operation
                    ref.read(todoData.notifier).addData([
                      User(
                        title: _contTitle.text,
                        description: _contDescription.text,
                      )
                    ]).whenComplete(() {
                      clearFn();
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

textFormWidget(TextEditingController controller, bool val, String hint) {
  return TextFormField(
    controller: controller,
    maxLines: val ? 5 : 1,
    decoration: InputDecoration(
      labelText: hint,
      hintText: 'Type something',
      // Set border properties here
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.blue, // Set your desired border color
          width: 2.0, // Set your desired border width
        ),
      ),
    ),
  );
}
