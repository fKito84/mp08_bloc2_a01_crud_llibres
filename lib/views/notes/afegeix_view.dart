import 'package:flutter/material.dart';
import '../../JsonModels/llibre_model.dart';
import 'package:mp08_bloc2_a01_crud_llibres/persistencia/dbhelper.dart';
import 'package:mp08_bloc2_a01_crud_llibres/settings/constants_view.dart';
import 'package:mp08_bloc2_a01_crud_llibres/views/notes/common_controls_view.dart';

//import '../../settings/constants_view.dart';



class Afegeix extends StatefulWidget {
  const Afegeix({super.key});

  @override
  State<Afegeix> createState() => _AfegeixState();
}

class _AfegeixState extends State<Afegeix> {
  //final textEditingControllerTitol = TextEditingController();
  //final textEditingControllerContingut = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final commonControlsView = CommonControlsView();
  final databaseHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantsView.LABEL_LLISTA_LLIBRES_TITOL),
        actions: [
          _getSaveIconButton(),
        ],
      ),
      body: Form(
        //I forgot to specify key
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                commonControlsView.getTextFormFieldTitol(
                    ConstantsView.LABEL_LLIBRE_TITOL, commonControlsView.textEditingControllerTitol),
                commonControlsView.getTextFormFieldContingut(
                    (ConstantsView.LABEL_LLIBRE_CONTINGUT), commonControlsView.textEditingControllerContingut),
              ],
            ),
          )),
    );
  }

  IconButton _getSaveIconButton() {
    return IconButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            databaseHelper
                .createLlibre(LlibreModel(
                llibreTitle: commonControlsView.textEditingControllerTitol.text,
                llibreContent: commonControlsView.textEditingControllerContingut.text,
                createdAt: DateTime.now().toIso8601String()))
                .whenComplete(() {
              Navigator.of(context).pop(true);
            });
          }
        },
        icon: Icon(Icons.save));
  }
}


