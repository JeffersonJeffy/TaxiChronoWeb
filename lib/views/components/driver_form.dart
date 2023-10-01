import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../constants/constants.dart';
import '../../../localizations/localization.dart';
import '../../controller/simple_ui_controller.dart';
import '../../models/driver_model.dart';
import '../../models/user_account_model.dart';


class DriverForm extends StatefulWidget {
  const DriverForm({Key? key, this.admin}) : super(key: key);
  final Administrator? admin;

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _db = FirebaseFirestore.instance;
  AppLocalizations? localization;
  Logger? logger;
  final _formKey = GlobalKey<FormState>();
  Driver driver = Driver();
  String? _genre;
  bool isLoading = false;
  var size;
  var theme;
  SimpleUIController? simpleUIController;
  Timestamp? timestampExpirePermiDate;

  TextEditingController nameController = TextEditingController();
  TextEditingController cniController = TextEditingController();
  TextEditingController bornController = TextEditingController();
  TextEditingController expectedCniController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController quarterController = TextEditingController();
  TextEditingController sexeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController expirePermiDateController = TextEditingController();
  TextEditingController numeroPermiController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    logger = Logger();
    simpleUIController = Get.put(SimpleUIController());
  }

  @override
  void dispose() {
    nameController.dispose();
    cniController.dispose();
    bornController.dispose();
    expectedCniController.dispose();
    countryController.dispose();
    quarterController.dispose();
    sexeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    expirePermiDateController.dispose();
    numeroPermiController.dispose();
    passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization!.trans('form_save')!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: textColor,
              ),
            ),
            const SizedBox(
              height: appPadding,
            ),
            /// first and last name
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.userName = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Nom & Prénom',
                label: Text('Nom & Prénom', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: nameController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// cni
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.userCni = val,
              decoration: const InputDecoration(
                label: Text('N° CNI', style: TextStyle(color: Colors.grey),),
                prefixIcon: Icon(Icons.perm_identity),
                hintText: 'N° CNI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: cniController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// expected cni
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.expireCniDate = val,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range_rounded),
                hintText: 'Date d\'expiration cni Ex: jj-mm-aaaa',
                label: Text('Date d\'expiration cni Ex: jj-mm-aaaa', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: expectedCniController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),


            /// expected Permi Date
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.expirePermiDate = transformDateToTimestamp(val!.trim()),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range_rounded),
                hintText: 'Date d\'expiration permis Ex: jj-mm-aaaa',
                label: Text('Date d\'expiration permis Ex: jj-mm-aaaa', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: expirePermiDateController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),


            /// N°Permi de conduire
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.numeroPermi = val,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('N° Permis de Conduire', style: TextStyle(color: Colors.grey),),
                prefixIcon: Icon(Icons.perm_identity),
                hintText: 'N° Permis de Conduire ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: numeroPermiController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),


            /// Quartier
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.quartier = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                hintText: 'Quartier ',
                label: Text('Quartier', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: quarterController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// Genre
            DropdownButtonFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                hintText: 'Genre ',
                label: Text('Genre', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),
              value: _genre,
              items: const [
                DropdownMenuItem(
                  value: 'M',
                  child: Text('Masculin'),
                ),
                DropdownMenuItem(
                  value: 'F',
                  child: Text('Féminin'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _genre = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le genre est obligatoire';
                }
                return null;
              },
            ),

            SizedBox(
              height: size.height * 0.02,
            ),

            /// phone
            TextFormField(
              style: kTextFormFieldStyle(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.phone,
              onSaved: (val) => driver.userTelephone = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: 'Téléphone ',
                label: Text('Téléphone', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: phoneController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                }else if (!value.isPhoneNumber) {
                  return localization?.trans('enter_phone_number');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// born
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.dateNaissance = val,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range),
                hintText: 'Date de Naissance Ex: jj-mm-yyyy',
                label: Text('Date de Naissance jj-mm-yyyy', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              controller: bornController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// Email
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => driver.userEmail = val,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                label: Text('Adresse Email', style: TextStyle(color: Colors.grey),),
                prefixIcon: Icon(Icons.email_rounded),
                hintText: 'Adresse Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_email');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                }else if (!value.isEmail) {
                  return localization?.trans('please_enter_valid_email');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// password
            Obx(
                  () => TextFormField(
                style: kTextFormFieldStyle(),
                controller: passwordController,
                onSaved: (val) => driver.password = val,
                obscureText: simpleUIController!.isObscure.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_open),
                  suffixIcon: IconButton(
                    icon: Icon(
                      simpleUIController!.isObscure.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      simpleUIController!.isObscureActive();
                    },
                  ),
                  hintText: 'Mot de passe',
                  label: const Text('Mot de passe', style: TextStyle(color: Colors.grey),),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization?.trans('please_enter_password');
                  } else if (value.length < 4) {
                    return localization?.trans('at_leaster_enter');
                  } else if (value.length > 20) {
                    return localization?.trans('maximum_character');
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),

            /// SignUp Button
            signUpButton(theme),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            setState(() {
              isLoading = true;
            });
            driver.sexe = _genre;
            driver.access = false;
            driver.createdBy = widget.admin?.id;
            driver.createdAt = Timestamp.now();
            await createDriverFromUser(driver);
          }
        },
        child: isLoading?  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization!.trans("loading")!, style: const TextStyle(fontSize: 20),),
            const SizedBox(width: 10,),
            const CircularProgressIndicator(color: Colors.white,),
          ],
        ) : Text(localization!.trans('validate')!, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  createDriverFromUser(Driver driver) async {
    print("-------Insert User------");
    logger?.d(driver.toUserMap());

    DocumentReference docRef = await _db.collection("Utilisateur").add(driver.toUserMap());
    String userId = docRef.id; // Récupérer l'ID généré du document

    // Utilisez l'ID de l'utilisateur comme vous le souhaitez
    // Par exemple, vous pouvez l'enregistrer dans un champ "Utilisateur" dans le document
    await _db.collection("Utilisateur").doc(userId).update({"userid": userId}).then((docRef) async {
      driver.id = userId;
      driver.userid = userId;
      await createDriver(driver);
    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
      showAlertDialog(context, error.toString());
    });

  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(localization!.trans("error_message")!),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  createDriver(Driver driver) async {
    print("-------Insert driver------");
    logger?.d(driver.toMapDriver());
    await _db.collection("Chauffeur").add(driver.toMapDriver()).whenComplete(() async {
      setState(() {
        isLoading = false;
      });
      logger?.i("Votre compte a ete crée avec succès.");
      //showAlertDialog(context, "Votre compte a ete crée avec succès.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre compte a ete crée avec succès."),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        nameController.clear();
        cniController.clear();
        bornController.clear();
        expectedCniController.clear();
        countryController.clear();
        quarterController.clear();
        sexeController.clear();
        phoneController.clear();
        emailController.clear();
        expirePermiDateController.clear();
        numeroPermiController.clear();
        passwordController.clear();
      });

    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
      showAlertDialog(context, error);
    });
  }

  Timestamp? transformDateToTimestamp(String date) {
    try{
      DateTime originalDate = DateFormat("dd-MM-yyyy").parse(date);
      String transformedDateString = DateFormat("yyyy-MM-dd").format(originalDate);
      timestampExpirePermiDate = Timestamp.fromMicrosecondsSinceEpoch(DateTime.parse(transformedDateString).microsecondsSinceEpoch);
      logger!.d(timestampExpirePermiDate);
    } catch (e){
      print("La valeur de dateTimeExpirePermiDate n'est pas une date valide: $e");
    }
    return timestampExpirePermiDate;
  }

}