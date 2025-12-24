import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mp08_bloc2_a01_crud_llibres/JsonModels/llibre_model.dart';
import 'package:mp08_bloc2_a01_crud_llibres/persistencia/dbhelper.dart';
import 'package:mp08_bloc2_a01_crud_llibres/settings/constants_view.dart';
import 'package:mp08_bloc2_a01_crud_llibres/Views/Notes/afegeix_view.dart';
import 'package:mp08_bloc2_a01_crud_llibres/views/notes/common_controls_view.dart';

class Llista extends StatefulWidget {
  const Llista({super.key});

  @override
  State<Llista> createState() => _LlibresState();
}

class _LlibresState extends State<Llista> {
  late DatabaseHelper databaseHelper;
  late Future<List<LlibreModel>> llistaLlibres;

  final commonControlsView = CommonControlsView();
  final searchTextEditingController = TextEditingController();

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    llistaLlibres = databaseHelper.getLlibres();

    databaseHelper.initDB().whenComplete(() {
      llistaLlibres = getAllLlibres();
    });
    super.initState();
  }

  Future<List<LlibreModel>> getAllLlibres() {
    return databaseHelper.getLlibres();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<LlibreModel>> searchLlibres() async{
    return databaseHelper.searchLlibres(searchTextEditingController.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      llistaLlibres = getAllLlibres();
    });
  }

  AppBar _getAppBar(String pTitolAppBar) {
    return AppBar(
      title: Text(pTitolAppBar),
    );
  }

  FloatingActionButton _getAfegeixView() {
    return FloatingActionButton(
      backgroundColor: Colors.green,  // ✅ Directo
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Afegeix()))
            .then((value) {
          if (value) {
            _refresh();
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }


  Container _getCercador() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: searchTextEditingController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              llistaLlibres = searchLlibres();
            });
          } else {
            setState(() {
              llistaLlibres = getAllLlibres();
            });
          }
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: ConstantsView.LABEL_CERCAR),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(ConstantsView.LABEL_LLISTA_LLIBRES_TITOL),
        floatingActionButton: _getAfegeixView(),
        body: Column(
          children: [
            //Search Field here
            _getCercador(),
            Expanded(
              child: FutureBuilder<List<LlibreModel>>(
                future: llistaLlibres,
                builder: (BuildContext context,
                    AsyncSnapshot<List<LlibreModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(child: Text(ConstantsView.MESSAGE_SENSE_DADES));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <LlibreModel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(items[index].llibreTitle),
                            subtitle: Text(DateFormat("yMd").format(
                                DateTime.parse(items[index].createdAt))),
                            trailing: _getDeleteIcon(items, index),
                            onTap: () {
                              _updateEnvironment(items, index);
                            },
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }

  IconButton _getDeleteIcon(List<LlibreModel> items, int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        databaseHelper.deleteLlibre(items[index].llibreId!).whenComplete(() {
          _refresh();
        });
      },
    );
  }

  void _updateEnvironment(List<LlibreModel> items, int index) {
    //When we click on note
    setState(() {
      commonControlsView.textEditingControllerTitol.text =
          items[index].llibreTitle;
      commonControlsView.textEditingControllerContingut.text =
          items[index].llibreContent;
    });
    showDialog(
        context: context,
        builder: (context) {
          return _getAlertDialogUpdate(items, index);
        });
  }

  AlertDialog _getAlertDialogUpdate(List<LlibreModel> items, int index) {
    return AlertDialog(
      title: Text(ConstantsView.LABEL_CANVIAR_TITOL),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        commonControlsView.getTextFormFieldTitol(
            ConstantsView.LABEL_LLISTA_LLIBRES_TITOL, commonControlsView.textEditingControllerTitol),
        commonControlsView.getTextFormFieldContingut(
            (ConstantsView.LABEL_LLISTA_LLIBRES_TITOL), commonControlsView.textEditingControllerContingut),
      ]),
      actions: [
        Row(
          children: [
            _getTextButtonCanviar(items, index),
            _getTextButtonCancel(),
          ],
        ),
      ],
    );
  }

  TextButton _getTextButtonCanviar(List<LlibreModel> items, int index) {
    return TextButton(
      onPressed: () {
        databaseHelper
            .updateLlibre(
                commonControlsView.textEditingControllerTitol.text,
                commonControlsView.textEditingControllerContingut.text,
                items[index].llibreId)
            .whenComplete(() {
          //After update, llibre will refresh
          _refresh();
          Navigator.pop(context);
        });
      },
      child: Text(ConstantsView.LABEL_LLISTA_LLIBRES_TITOL),
    );
  }

  TextButton _getTextButtonCancel() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(ConstantsView.LABEL_LLISTA_LLIBRES_TITOL),
    );
  }
}
