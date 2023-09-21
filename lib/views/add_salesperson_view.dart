import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';
import 'package:taxi_chrono_web/models/salesperson_model.dart';
import 'package:taxi_chrono_web/views/salesperson_view.dart';
import '../constants/constants.dart';
import '../controller/simple_ui_controller.dart';
import '../localizations/localization.dart';

class AddSalesPersonView extends StatefulWidget {
  const AddSalesPersonView({Key? key, this.admin}) : super(key: key);
  static const String pageName = "add/salesperson";
  final Administrator? admin;

  @override
  State<AddSalesPersonView> createState() => _AddSalesPersonViewState();
}

class _AddSalesPersonViewState extends State<AddSalesPersonView> {

  TextEditingController nameController = TextEditingController();
  TextEditingController cniController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController bornController = TextEditingController();
  TextEditingController expectedCniController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController quarterController = TextEditingController();
  TextEditingController sexeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AppLocalizations localization;
  var logger = Logger();
  final _db = FirebaseFirestore.instance;
  SalesPerson salesPerson = SalesPerson();
  String? _genre;
  String? _codePromo;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _codePromo = generatePromoCode();
  }

  @override
  void dispose() {
    nameController.dispose();
    cniController.dispose();
    //promoCodeController.dispose();
    bornController.dispose();
    expectedCniController.dispose();
    countryController.dispose();
    quarterController.dispose();
    sexeController.dispose();
    phoneController.dispose();
    roleController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            ),
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 4,
            child: Image.asset(
              'assets/images/logo.jpg',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
      size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Image.asset(
          'assets/images/logo.jpg',
          height: size.height * 0.2,
          width: size.width,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            localization.trans('salesperson')!,
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            localization.trans('create_account')!,
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// first and last name
                TextFormField(
                  style: kTextFormFieldStyle(),
                  onSaved: (val) => salesPerson.userName = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Nom & Prénom',
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
                      return localization.trans('please_enter_field');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                  onSaved: (val) => salesPerson.userCni = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.perm_identity),
                    hintText: 'CNI',
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
                      return localization.trans('please_enter_field');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                  onSaved: (val) => salesPerson.expireCniDate = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.date_range_rounded),
                    hintText: 'Date d\'expiration cni Ex: 12-10-2028',
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
                      return localization.trans('please_enter_field');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                  onSaved: (val) => salesPerson.quartier = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.abc_outlined),
                    hintText: 'Quartier ',
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
                      return localization.trans('please_enter_field');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                  keyboardType: TextInputType.phone,
                  onSaved: (val) => salesPerson.userTelephone = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Téléphone ',
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
                      return localization.trans('please_enter_field');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    }else if (!value.isPhoneNumber) {
                      return localization.trans('enter_phone_number');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                  keyboardType: TextInputType.datetime,
                  onSaved: (val) => salesPerson.dateNaissance = val,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.date_range),
                    hintText: 'Date de Naissance Ex: 02-01-1985',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),

                  controller: bornController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.trans('please_enter_field');
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
                  onSaved: (val) => salesPerson.userEmail = val,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    hintText: 'Email',
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
                      return localization.trans('please_enter_email');
                    } else if (value.length < 4) {
                      return localization.trans('at_leaster_enter');
                    }else if (!value.isEmail) {
                      return localization.trans('please_enter_valid_email');
                    } else if (value.length > 50) {
                      return localization.trans('maximum_character');
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
                    onSaved: (val) => salesPerson.password = val,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
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
                        return localization.trans('please_enter_password');
                      } else if (value.length < 4) {
                        return localization.trans('at_leaster_enter');
                      } else if (value.length > 20) {
                        return localization.trans('maximum_character');
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// promo code
                TextFormField(
                  style: kTextFormFieldStyle(),
                  keyboardType: TextInputType.text,
                  onSaved: (val) => _codePromo = val,
                  initialValue: _codePromo,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.code_off),
                    hintText: 'Code Promo',
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
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // SignUp Button
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
            setState(() {
              isLoading = true;
            });
            // ... Navigate To your Login
            salesPerson.userName = nameController.text;
            salesPerson.userCni = cniController.text;
            salesPerson.dateNaissance = bornController.text;
            salesPerson.expireCniDate = expectedCniController.text;
            salesPerson.quartier = quarterController.text;
            salesPerson.sexe = _genre;
            salesPerson.userTelephone = phoneController.text;
            salesPerson.userEmail = emailController.text;
            salesPerson.password = passwordController.text;
            salesPerson.promoCode = "${extractFirstTwoCharacters(nameController.text)}${_codePromo!}";
            salesPerson.access = false;
            salesPerson.createdBy = widget.admin?.id;
            await createUserAccountWithEmailPassword(salesPerson);
          }
        },
        child: isLoading?  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization.trans("loading")!, style: const TextStyle(fontSize: 20),),
            const SizedBox(width: 10,),
            const CircularProgressIndicator(color: Colors.white,),
          ],
        ) : Text(localization.trans('validate')!, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  createSalesPerson(SalesPerson salesPerson) async {
    logger.d(salesPerson.toMap());
    await _db.collection("Commerciaux").add(salesPerson.toMap()).whenComplete(() async {
      setState(() {
        isLoading = false;
      });
      logger.i("Votre compte a ete crée avec succès.");
      //showAlertDialog(context, "Votre compte a ete crée avec succès.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre compte a ete crée avec succès."),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context)
          .pushNamed(SalesPersonView.pageName, arguments: {
        "admin": widget.admin
      });

    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
        ),
      );
      showAlertDialog(context, error);
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
      title: Text(localization.trans("error_message")!),
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

  String generatePromoCode() {
    Random random = Random();
    String promoCode = '';
    for (int i = 0; i < 7; i++) {
      promoCode += random.nextInt(10).toString();
    }
    return promoCode;
  }

  Future<void> createUserAccountWithEmailPassword(SalesPerson salesPerson) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: salesPerson.userEmail!,
        password: salesPerson.password!,
      );

      String salePersonId = userCredential.user!.uid;
      salesPerson.id = salePersonId;
      salesPerson.createdAt = Timestamp.now();

      createSalesPerson(salesPerson);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String extractFirstTwoCharacters(String text) {
    if (text.length >= 2) {
      return text.substring(0, 2).toUpperCase();
    } else {
      return text; // Retourne la chaîne complète si elle contient moins de deux caractères
    }
  }
}
