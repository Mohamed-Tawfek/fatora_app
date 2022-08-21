import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../cubit/fatora_cubit.dart';
import '../cubit/fatora_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FatoraCubit()..getAllData(),
      child: BlocConsumer<FatoraCubit, FatoraState>(
          builder: (context, s) {
            return Scaffold(
              appBar: FatoraCubit.get(context).data.isEmpty? null:AppBar(
                actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    backgroundColor: Color(0xFF253341),
                                    title: Text(
                                      'هل تريد حذف الكل ؟!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      MaterialButton(
                                          onPressed: () {
                                            FatoraCubit.get(context)
                                                .deleteAllData()
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text(
                                            'نعم',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          color: Colors.red),
                                      MaterialButton(
                                        onPressed: () {
                                          FatoraCubit.get(context)
                                              .getAllData()
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          'لا',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                ));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      iconSize: 35,
                    )
                ],
              ),
              body: FatoraCubit.get(context).data.isEmpty
                  ? Center(
                      child: Text(
                      'لا توجد بيانات !!.. برجاء الضغط على + لاضافة سلعة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold),
                    ))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                              itemBuilder: (_, index) => BuildFatouraItem(
                                    contextCubit: context,
                                    id: FatoraCubit.get(context).data[index]
                                        ['id'],
                                    name: FatoraCubit.get(context).data[index]
                                        ['name'],
                                    price: FatoraCubit.get(context).data[index]
                                        ['price'],
                                  ),
                              separatorBuilder: (_, index) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    color: Color(0xFF253341),
                                    width: double.infinity,
                                    height: 1,
                                  ),
                              itemCount: FatoraCubit.get(context).data.length),
                        ),
                        if (FatoraCubit.get(context).total != 0)
                          Container(
                            margin: EdgeInsetsDirectional.all(20),
                            decoration: BoxDecoration(
                                color: Color(0xFF253341),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'الاجمالى :',
                                  style: TextStyle(
                                      fontSize: 40.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${FatoraCubit.get(context).total.round()} ',
                                  style: TextStyle(
                                      fontSize: 40.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF253341),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  showMaterialModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        color: Color(0xFF15202B),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: FatoraCubit.get(context).formKey,
                            child: Center(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    DefaultTextField(
                                      controller:
                                          FatoraCubit.get(context).priceController,
                                      label: 'سعر السلعة',
                                      validator: (String? data) {
                                        if (data!.isEmpty) {
                                          return 'لا يجب ان يكون فارغا';
                                        }
                                        try {
                                          double.parse(data);
                                        } catch (e) {
                                          return 'برجاء ادخال اعداد فقط';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    DefaultTextField(
                                      controller:
                                          FatoraCubit.get(context).nameController,
                                      label: 'اسم السلعة',
                                      validator: (String? data) {
                                        if (data!.isEmpty) {
                                          return 'لا يجب ان يكون فارغا';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        if (FatoraCubit.get(context)
                                            .formKey
                                            .currentState!
                                            .validate()) {
                                          print(FatoraCubit.get(context)
                                              .priceController
                                              .text);
                                          FatoraCubit.get(context)
                                              .insertToDB(
                                            date: DateTime.now().toString().substring(0,10),
                                                  name: FatoraCubit.get(context)
                                                      .nameController
                                                      .text,
                                                  price: FatoraCubit.get(context)
                                                      .priceController
                                                      .text)
                                              .then((value) {
                                            FatoraCubit.get(context)
                                                .nameController
                                                .clear();
                                            FatoraCubit.get(context)
                                                .priceController
                                                .clear();
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      color: Color(0xFF253341),
                                      child: Text(
                                        'اضف',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          listener: (context, s) {}),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const DefaultTextField({
    Key? key,
    required this.label,
    required this.validator,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}

class BuildFatouraItem extends StatefulWidget {
  const BuildFatouraItem(
      {Key? key,
      required this.name,
      required this.price,
      required this.id,
      required this.contextCubit})
      : super(key: key);
  final double price;
  final String name;
  final int id;
  final BuildContext contextCubit;

  @override
  State<BuildFatouraItem> createState() => _BuildFatouraItemState();
}

class _BuildFatouraItemState extends State<BuildFatouraItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        showDialog(
            context: context,
            builder: (_) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    backgroundColor: Color(0xFF253341),
                    title: Text(
                      'هل تريد الحذف ؟',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            FatoraCubit.get(context)
                                .deleteASpecificItem(id: widget.id)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'نعم',
                            style: TextStyle(fontSize: 30),
                          ),
                          color: Colors.red),
                      MaterialButton(
                        onPressed: () {
                          FatoraCubit.get(context).getAllData().then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'لا',
                          style: TextStyle(fontSize: 30),
                        ),
                        color: Colors.green,
                      )
                    ],
                  ),
                )).then((value) {
          setState(() {});
        });
      },
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF253341)),
              child: Text(
                '${widget.price.round()}',
                style: const TextStyle(color: Colors.white, fontSize: 40.0),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(color: Colors.white, fontSize: 35.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
