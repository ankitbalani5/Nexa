
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/AllShippingAddressBloc/all_shipping_address_bloc.dart';
import 'package:nexa/Model/CityModel.dart';
import 'package:nexa/Model/CountryModel.dart';
import 'package:nexa/Model/StateModel.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart' as screen;

import '../../../Bloc/AddShippingAddressBloc/add_shipping_address_bloc.dart';
import '../../../Bloc/CityBloc/city_bloc.dart';
import '../../../Bloc/CountryBloc/country_bloc.dart';
import '../../../Bloc/StateBloc/state_bloc.dart';
import '../../../Constant.dart';
import '../../../Model/AllShippingAddressModel.dart';
import '../../../Widget/Btn.dart';

class AddShippingAddress extends StatefulWidget {
  String path;
  AddShippingAddress({required this.path, super.key});

  @override
  State<AddShippingAddress> createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress> {
  var _formKey = GlobalKey<FormState>();
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool address = false;
  var primeryAddress = 0;
  CountryModel? countryModel;
  StateModel? stateModel;
  CityModel? cityModel;
  var stateEnable = false;
  var cityEnable = false;
  late StateBloc _stateBloc;
  late CityBloc _cityBloc;
  String _countryName = 'PH'; // Default country code
  String _countryCode = '+63'; // Default country code
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var zipController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  void initState() {
    context.read<CountryBloc>().add(CountryRefreshEvent());
    _stateBloc = StateBloc();
    _cityBloc = CityBloc();
    // fetchData();
    super.initState();
  }

  @override
  void dispose() {
    countryModel?.country?.clear();
    stateModel?.states?.clear();
    cityModel?.cities?.clear();
    _stateBloc.close();
    _cityBloc.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(widget.path == 'checkout'){
          context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  if(widget.path == 'checkout'){
                    context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
                  }
                  Navigator.pop(context);
                },
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
          ),
          title: const Text('Add Shipping Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        ),
        body: BlocConsumer<AddShippingAddressBloc, AddShippingAddressState>(
          listener: (context, state) {
            if(state is AddShippingAddressLoading){
              Constant.showDialogProgress(context);
              /*Container(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
                  ),
                );*/
            }
            if(state is AddShippingAddressSuccess){
              Navigator.pop(context);
              if(widget.path == 'checkout'){
                Navigator.pop(context);
                context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
              }else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen.ShippingAddress()));
              }
              // Navigator.pushReplacement(event.context,
              //     PageTransition(child: ShippingAddress(), type: PageTransitionType.rightToLeft));
            }
          },
          builder: (context, state) {
            return BlocBuilder<CountryBloc, CountryState>(
              builder: (context, state) {
                if(state is CountryLoading){
                  return IgnorePointer(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  const SizedBox(height: 20,),
                                  const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Constant.bgTextfieldHint,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        filled: true,
                                        hintText: 'Enter name',
                                        hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                        fillColor: Constant.bgTextField,
                                        // contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        )
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15,),
                                  const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Constant.bgTextfieldHint,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        filled: true,
                                        hintText: 'Enter address',
                                        hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                        fillColor: Constant.bgTextField,
                                        // contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        )
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Country', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                      DropdownSearch<Country?>(
                                        items: [],
                                        itemAsString: (item) => item!.name.toString(),
                                        onChanged: (value) {
                                          // stateEnable = false;
                                          cityEnable = false;
                                          stateModel?.states?.clear();
                                          cityModel?.cities?.clear();
                                          selectedCountry = value?.name;
                                          // selectedCity!.name = '';
                                          print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                                          // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                                          // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                                          // _stateBloc.add(SelectStateEvent(value!.id.toString()));
                                          // _cityBloc.add(SelectCityEvent(''));
                                          // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                        },
                                        popupProps: const PopupProps.menu(
                                            showSearchBox: true
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                              suffixIconColor: Constant.bgOrangeLite,
                                              filled: true,
                                              fillColor: Constant.bgTextField,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              hintText: 'Select Country',
                                              hintStyle: const TextStyle(
                                                  color: Constant.bgTextfieldHint
                                              )
                                          ),
                                          baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                        ),
                                        validator: (item) {
                                          if (item == null)
                                            return "Required field";
                                          else
                                            return null;
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('State/Province/Region', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                      BlocBuilder<StateBloc, StateState>(
                                        bloc: _stateBloc,
                                        builder: (context, state) {
                                          if(state is StateSuccess){
                                            stateModel = state.stateModel;
                                            return DropdownSearch<States?>(
                                              items: stateModel!.states!,
                                              itemAsString: (item) => item!.name.toString(),
                                              onChanged: (value) {
                                                cityEnable = false;
                                                cityModel?.cities?.clear();
                                                selectedState = value?.name;
                                                _cityBloc.add(SelectCityEvent(value!.id.toString()));
                                                // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(value!.id.toString()));

                                                // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                              },
                                              popupProps: const PopupProps.menu(
                                                  showSearchBox: true
                                              ),
                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                dropdownSearchDecoration: InputDecoration(
                                                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                    suffixIconColor: Constant.bgOrangeLite,
                                                    filled: true,
                                                    fillColor: Constant.bgTextField,
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.transparent)
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.transparent)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.transparent)
                                                    ),
                                                    hintText: 'Select State',
                                                    hintStyle: const TextStyle(
                                                        color: Constant.bgTextfieldHint
                                                    )
                                                ),
                                                baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                              ),
                                              validator: (item) {
                                                if (item == null)
                                                  return "Required field";
                                                else
                                                  return null;
                                              },
                                            );
                                          }
                                          return Opacity(
                                            opacity: stateEnable ? 1.0 : 0.5,
                                            child: DropdownSearch(
                                              items: [],
                                              enabled: stateEnable,
                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                  dropdownSearchDecoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                      suffixIconColor: Constant.bgOrangeLite,
                                                      filled: true,
                                                      fillColor: Constant.bgTextField,
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                          borderSide: const BorderSide(color: Colors.transparent)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                          borderSide: const BorderSide(color: Colors.transparent)
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                          borderSide: const BorderSide(color: Colors.transparent)
                                                      ),

                                                      hintText: 'Select State',
                                                      hintStyle: const TextStyle(
                                                          color: Constant.bgTextfieldHint
                                                      )
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Column(
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: [
                                  //           const Text('Country'),
                                  //           DropdownSearch<Country?>(
                                  //             items: [],
                                  //             itemAsString: (item) => item!.name.toString(),
                                  //             onChanged: (value) {
                                  //               // stateEnable = false;
                                  //               cityEnable = false;
                                  //               stateModel?.states?.clear();
                                  //               cityModel?.cities?.clear();
                                  //               selectedCountry = value?.name;
                                  //               // selectedCity!.name = '';
                                  //               print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                                  //               // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                                  //               // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                                  //               // _stateBloc.add(SelectStateEvent(value!.id.toString()));
                                  //               // _cityBloc.add(SelectCityEvent(''));
                                  //               // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                  //             },
                                  //             popupProps: const PopupProps.menu(
                                  //                 showSearchBox: true
                                  //             ),
                                  //             dropdownDecoratorProps: DropDownDecoratorProps(
                                  //               dropdownSearchDecoration: InputDecoration(
                                  //                   suffixIconColor: Constant.bgOrangeLite,
                                  //                   filled: true,
                                  //                   fillColor: Constant.bgTextField,
                                  //                   border: OutlineInputBorder(
                                  //                       borderRadius: BorderRadius.circular(12),
                                  //                       borderSide: const BorderSide(color: Colors.transparent)
                                  //                   ),
                                  //                   enabledBorder: OutlineInputBorder(
                                  //                       borderRadius: BorderRadius.circular(12),
                                  //                       borderSide: const BorderSide(color: Colors.transparent)
                                  //                   ),
                                  //                   focusedBorder: OutlineInputBorder(
                                  //                       borderRadius: BorderRadius.circular(12),
                                  //                       borderSide: const BorderSide(color: Colors.transparent)
                                  //                   ),
                                  //                   hintText: 'Select Country',
                                  //                   hintStyle: const TextStyle(
                                  //                       color: Constant.bgTextfieldHint
                                  //                   )
                                  //               ),
                                  //               baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                  //             ),
                                  //             validator: (item) {
                                  //               if (item == null)
                                  //                 return "Required field";
                                  //               else
                                  //                 return null;
                                  //             },
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 10,),
                                  //     Expanded(
                                  //       child: Column(
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: [
                                  //           const Text('State/Province/Region'),
                                  //           BlocBuilder<StateBloc, StateState>(
                                  //             bloc: _stateBloc,
                                  //             builder: (context, state) {
                                  //               if(state is StateSuccess){
                                  //                 stateModel = state.stateModel;
                                  //                 return DropdownSearch<States?>(
                                  //                   items: stateModel!.states!,
                                  //                   itemAsString: (item) => item!.name.toString(),
                                  //                   onChanged: (value) {
                                  //                     cityEnable = false;
                                  //                     cityModel?.cities?.clear();
                                  //                     selectedState = value?.name;
                                  //                     _cityBloc.add(SelectCityEvent(value!.id.toString()));
                                  //                     // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(value!.id.toString()));
                                  //
                                  //                     // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                  //                   },
                                  //                   popupProps: const PopupProps.menu(
                                  //                       showSearchBox: true
                                  //                   ),
                                  //                   dropdownDecoratorProps: DropDownDecoratorProps(
                                  //                     dropdownSearchDecoration: InputDecoration(
                                  //                         suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  //                         suffixIconColor: Constant.bgOrangeLite,
                                  //                         filled: true,
                                  //                         fillColor: Constant.bgTextField,
                                  //                         border: OutlineInputBorder(
                                  //                             borderRadius: BorderRadius.circular(12),
                                  //                             borderSide: const BorderSide(color: Colors.transparent)
                                  //                         ),
                                  //                         enabledBorder: OutlineInputBorder(
                                  //                             borderRadius: BorderRadius.circular(12),
                                  //                             borderSide: const BorderSide(color: Colors.transparent)
                                  //                         ),
                                  //                         focusedBorder: OutlineInputBorder(
                                  //                             borderRadius: BorderRadius.circular(12),
                                  //                             borderSide: const BorderSide(color: Colors.transparent)
                                  //                         ),
                                  //                         hintText: 'Select State',
                                  //                         hintStyle: const TextStyle(
                                  //                             color: Constant.bgTextfieldHint
                                  //                         )
                                  //                     ),
                                  //                     baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                  //                   ),
                                  //                   validator: (item) {
                                  //                     if (item == null)
                                  //                       return "Required field";
                                  //                     else
                                  //                       return null;
                                  //                   },
                                  //                 );
                                  //               }
                                  //               return Opacity(
                                  //                 opacity: stateEnable ? 1.0 : 0.5,
                                  //                 child: DropdownSearch(
                                  //                   items: [],
                                  //                   enabled: stateEnable,
                                  //                   dropdownDecoratorProps: DropDownDecoratorProps(
                                  //                       dropdownSearchDecoration: InputDecoration(
                                  //                           suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  //                           suffixIconColor: Constant.bgOrangeLite,
                                  //                           filled: true,
                                  //                           fillColor: Constant.bgTextField,
                                  //                           border: OutlineInputBorder(
                                  //                               borderRadius: BorderRadius.circular(12),
                                  //                               borderSide: const BorderSide(color: Colors.transparent)
                                  //                           ),
                                  //                           enabledBorder: OutlineInputBorder(
                                  //                               borderRadius: BorderRadius.circular(12),
                                  //                               borderSide: const BorderSide(color: Colors.transparent)
                                  //                           ),
                                  //                           focusedBorder: OutlineInputBorder(
                                  //                               borderRadius: BorderRadius.circular(12),
                                  //                               borderSide: const BorderSide(color: Colors.transparent)
                                  //                           ),
                                  //
                                  //                           hintText: 'Select State',
                                  //                           hintStyle: const TextStyle(
                                  //                               color: Constant.bgTextfieldHint
                                  //                           )
                                  //                       )
                                  //                   ),
                                  //                 ),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 15,),
                                  const Text('City', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  BlocBuilder<CityBloc, CityState>(
                                    bloc: _cityBloc,
                                    builder: (context, state) {
                                      if(state is CitySuccess){
                                        cityModel = state.cityModel;
                                        return DropdownSearch<Cities?>(
                                          items: cityModel!.cities!,
                                          itemAsString: (item) => item!.name.toString(),
                                          popupProps: const PopupProps.menu(
                                              showSearchBox: true
                                          ),
                                          dropdownDecoratorProps: DropDownDecoratorProps(
                                            dropdownSearchDecoration: InputDecoration(
                                                suffixIconColor: Constant.bgOrangeLite,
                                                filled: true,
                                                fillColor: Constant.bgTextField,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                                hintText: 'Select City',
                                                hintStyle: const TextStyle(
                                                    color: Constant.bgTextfieldHint
                                                )
                                            ),
                                            baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                          ),
                                          validator: (item) {
                                            if (item == null)
                                              return "Required field";
                                            else
                                              return null;
                                          },
                                        );
                                      }
                                      return Opacity(
                                        opacity: cityEnable ? 1.0 : 0.5,
                                        child: DropdownSearch(
                                          enabled: cityEnable,
                                          items: [],
                                          dropdownDecoratorProps: DropDownDecoratorProps(
                                              dropdownSearchDecoration: InputDecoration(
                                                  suffixIconColor: Constant.bgOrangeLite,
                                                  filled: true,
                                                  fillColor: Constant.bgTextField,
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Colors.transparent)
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Colors.transparent)
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Colors.transparent)
                                                  ),
                                                  hintText: 'Select City',
                                                  hintStyle: const TextStyle(
                                                      color: Constant.bgTextfieldHint
                                                  )
                                              )
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // SizedBox(
                                  //   // color: Colors.red,
                                  //   height: 60,
                                  //   child: TextFormField(style: const TextStyle(color: Colors.white),
                                  //     decoration: InputDecoration(
                                  //         filled: true,
                                  //         hintText: 'California',
                                  //         hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                  //         fillColor: Constant.bgTextField,
                                  //         // contentPadding: EdgeInsets.all(10),
                                  //         enabledBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(12),
                                  //             borderSide: const BorderSide(color: Colors.transparent)
                                  //         ),
                                  //         focusedBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(12),
                                  //             borderSide: const BorderSide(color: Colors.transparent)
                                  //         ),
                                  //     ),
                                  //   ),
                                  // ),

                                  const SizedBox(height: 15,),
                                  const Text('Zip Code (Postal Code)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: Constant.bgTextfieldHint,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      filled: true,
                                      hintText: 'Enter Zip',
                                      hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                      fillColor: Constant.bgTextField,
                                      // contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      ),
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter Pin Code';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15,),
                                  const Text('Mobile Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      cursorColor: Constant.bgTextfieldHint,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                          filled: true,
                                          hintText: 'Enter mobile number',
                                          hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                          fillColor: Constant.bgTextField,
                                          // contentPadding: EdgeInsets.all(10),
                                          prefixIcon: CountryCodePicker(
                                            onChanged: (country) {
                                              setState(() {
                                                _countryCode = country.code!;
                                              });
                                            },
                                            initialSelection: _countryCode,
                                            showFlag: true,
                                            textStyle: TextStyle(color: Constant.bgTextfieldHint),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          )
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a phone number';
                                        }
                                        if (!Constant.validatePhoneNumber(value, _countryCode)) {
                                          return 'Invalid phone number for country $_countryCode';
                                        }
                                        return null; // Validation passed
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Save as primary address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                      Switch(
                                        value: address,
                                        activeColor: Constant.bgOrange,
                                        onChanged: (value) {
                                          address = value;
                                          setState(() {

                                          });
                                        },)
                                    ],
                                  ),
                                  const SizedBox(height: 30,),
                                  Btn('', height: 50, width: MediaQuery.of(context).size.width,
                                      linearColor1: Constant.bgLinearColor1,
                                      linearColor2: Constant.bgLinearColor2,
                                      name: 'Save Address', callBack: (){
                                        if(_formKey.currentState!.validate()){
                                          print('ok');
                                        }
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black26,
                          child: Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: Constant.bgOrangeLite,
                              size: 40,
                            ),),
                        ),
                      ],
                    ),
                  );
                }
                if(state is CountrySuccess){
                  countryModel = state.countryModel;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 20,),
                            const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            TextFormField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Constant.bgTextfieldHint,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  filled: true,
                                  hintText: 'Enter name',
                                  hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                  fillColor: Constant.bgTextField,
                                  // contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  )
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return 'Enter name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15,),
                            const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            TextFormField(
                              controller: addressController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Constant.bgTextfieldHint,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  filled: true,
                                  hintText: 'Enter address',
                                  hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                  fillColor: Constant.bgTextField,
                                  // contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.transparent)
                                  )
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return 'Enter address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Country', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                DropdownSearch<Country?>(
                                  items: countryModel!.country!,
                                  itemAsString: (item) => item!.name.toString(),
                                  onChanged: (value) {
                                    // stateEnable = false;
                                    cityEnable = false;
                                    stateModel?.states?.clear();
                                    cityModel?.cities?.clear();
                                    selectedCountry = value!.name;
                                    // selectedCity!.name = '';
                                    print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                                    // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                                    // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                                    _stateBloc.add(SelectStateEvent(value!.id.toString()));
                                    _cityBloc.add(SelectCityEvent(''));
                                    // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                  },
                                  popupProps: const PopupProps.menu(
                                      showSearchBox: true
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        suffixIconColor: Constant.bgOrangeLite,
                                        filled: true,
                                        fillColor: Constant.bgTextField,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent)
                                        ),
                                        hintText: 'Select Country',
                                        hintStyle: const TextStyle(
                                            color: Constant.bgTextfieldHint
                                        )
                                    ),
                                    baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                  ),
                                  validator: (item) {
                                    if (item == null)
                                      return "Required field";
                                    else
                                      return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('State/Province/Region', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                BlocBuilder<StateBloc, StateState>(
                                  bloc: _stateBloc,
                                  builder: (context, state) {
                                    if(state is StateSuccess){
                                      stateModel = state.stateModel;
                                      return DropdownSearch<States?>(
                                        items: stateModel!.states!,
                                        itemAsString: (item) => item!.name.toString(),
                                        onChanged: (value) {
                                          cityEnable = false;
                                          cityModel?.cities?.clear();
                                          selectedState = value!.name;
                                          _cityBloc.add(SelectCityEvent(value!.id.toString()));
                                          // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(value!.id.toString()));

                                          // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                                        },
                                        popupProps: const PopupProps.menu(
                                            showSearchBox: true
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                                              suffixIconColor: Constant.bgOrangeLite,
                                              filled: true,
                                              fillColor: Constant.bgTextField,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Colors.transparent)
                                              ),
                                              hintText: 'Select State',
                                              hintStyle: const TextStyle(
                                                  color: Constant.bgTextfieldHint
                                              )
                                          ),
                                          baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                        ),
                                        validator: (item) {
                                          if (item == null)
                                            return "Required field";
                                          else
                                            return null;
                                        },
                                      );
                                    }
                                    return Opacity(
                                      opacity: stateEnable ? 1.0 : 0.5,
                                      child: DropdownSearch(
                                        items: [],
                                        enabled: stateEnable,
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                            dropdownSearchDecoration: InputDecoration(
                                                suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                suffixIconColor: Constant.bgOrangeLite,
                                                filled: true,
                                                fillColor: Constant.bgTextField,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),

                                                hintText: 'Select State',
                                                hintStyle: const TextStyle(
                                                    color: Constant.bgTextfieldHint
                                                )
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           const Text('Country', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            //           DropdownSearch<Country?>(
                            //             items: countryModel!.country!,
                            //             itemAsString: (item) => item!.name.toString(),
                            //             onChanged: (value) {
                            //               // stateEnable = false;
                            //               cityEnable = false;
                            //               stateModel?.states?.clear();
                            //               cityModel?.cities?.clear();
                            //               selectedCountry = value!.name;
                            //               // selectedCity!.name = '';
                            //               print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                            //               // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                            //               // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                            //               _stateBloc.add(SelectStateEvent(value!.id.toString()));
                            //               _cityBloc.add(SelectCityEvent(''));
                            //               // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                            //             },
                            //             popupProps: const PopupProps.menu(
                            //                 showSearchBox: true
                            //             ),
                            //             dropdownDecoratorProps: DropDownDecoratorProps(
                            //               dropdownSearchDecoration: InputDecoration(
                            //                   suffixIconColor: Constant.bgOrangeLite,
                            //                   filled: true,
                            //                   fillColor: Constant.bgTextField,
                            //                   border: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.circular(12),
                            //                       borderSide: const BorderSide(color: Colors.transparent)
                            //                   ),
                            //                   enabledBorder: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.circular(12),
                            //                       borderSide: const BorderSide(color: Colors.transparent)
                            //                   ),
                            //                   focusedBorder: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.circular(12),
                            //                       borderSide: const BorderSide(color: Colors.transparent)
                            //                   ),
                            //                   hintText: 'Select Country',
                            //                   hintStyle: const TextStyle(
                            //                       color: Constant.bgTextfieldHint
                            //                   )
                            //               ),
                            //               baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                            //             ),
                            //             validator: (item) {
                            //               if (item == null)
                            //                 return "Required field";
                            //               else
                            //                 return null;
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10,),
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           const Text('State/Province/Region', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            //           BlocBuilder<StateBloc, StateState>(
                            //             bloc: _stateBloc,
                            //             builder: (context, state) {
                            //               if(state is StateSuccess){
                            //                 stateModel = state.stateModel;
                            //                 return DropdownSearch<States?>(
                            //                   items: stateModel!.states!,
                            //                   itemAsString: (item) => item!.name.toString(),
                            //                   onChanged: (value) {
                            //                     cityEnable = false;
                            //                     cityModel?.cities?.clear();
                            //                     selectedState = value!.name;
                            //                     _cityBloc.add(SelectCityEvent(value!.id.toString()));
                            //                     // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(value!.id.toString()));
                            //
                            //                     // context.read<CountryBloc>().add(SelectStateEvent(value?.id.toString()));
                            //                   },
                            //                   popupProps: const PopupProps.menu(
                            //                       showSearchBox: true
                            //                   ),
                            //                   dropdownDecoratorProps: DropDownDecoratorProps(
                            //                     dropdownSearchDecoration: InputDecoration(
                            //                         suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //                         suffixIconColor: Constant.bgOrangeLite,
                            //                         filled: true,
                            //                         fillColor: Constant.bgTextField,
                            //                         border: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(12),
                            //                             borderSide: const BorderSide(color: Colors.transparent)
                            //                         ),
                            //                         enabledBorder: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(12),
                            //                             borderSide: const BorderSide(color: Colors.transparent)
                            //                         ),
                            //                         focusedBorder: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(12),
                            //                             borderSide: const BorderSide(color: Colors.transparent)
                            //                         ),
                            //                         hintText: 'Select State',
                            //                         hintStyle: const TextStyle(
                            //                             color: Constant.bgTextfieldHint
                            //                         )
                            //                     ),
                            //                     baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                            //                   ),
                            //                   validator: (item) {
                            //                     if (item == null)
                            //                       return "Required field";
                            //                     else
                            //                       return null;
                            //                   },
                            //                 );
                            //               }
                            //               return Opacity(
                            //                 opacity: stateEnable ? 1.0 : 0.5,
                            //                 child: DropdownSearch(
                            //                   items: [],
                            //                   enabled: stateEnable,
                            //                   dropdownDecoratorProps: DropDownDecoratorProps(
                            //                       dropdownSearchDecoration: InputDecoration(
                            //                           suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //                           suffixIconColor: Constant.bgOrangeLite,
                            //                           filled: true,
                            //                           fillColor: Constant.bgTextField,
                            //                           border: OutlineInputBorder(
                            //                               borderRadius: BorderRadius.circular(12),
                            //                               borderSide: const BorderSide(color: Colors.transparent)
                            //                           ),
                            //                           enabledBorder: OutlineInputBorder(
                            //                               borderRadius: BorderRadius.circular(12),
                            //                               borderSide: const BorderSide(color: Colors.transparent)
                            //                           ),
                            //                           focusedBorder: OutlineInputBorder(
                            //                               borderRadius: BorderRadius.circular(12),
                            //                               borderSide: const BorderSide(color: Colors.transparent)
                            //                           ),
                            //
                            //                           hintText: 'Select State',
                            //                           hintStyle: const TextStyle(
                            //                               color: Constant.bgTextfieldHint
                            //                           )
                            //                       )
                            //                   ),
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 15,),
                            const Text('City', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            BlocBuilder<CityBloc, CityState>(
                              bloc: _cityBloc,
                              builder: (context, state) {
                                if(state is CitySuccess){
                                  cityModel = state.cityModel;
                                  return DropdownSearch<Cities?>(
                                    items: cityModel!.cities!,
                                    itemAsString: (item) => item!.name.toString(),
                                    popupProps: const PopupProps.menu(
                                        showSearchBox: true
                                    ),
                                    onChanged: (value) {
                                      selectedCity = value?.name;
                                    },
                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          suffixIconColor: Constant.bgOrangeLite,
                                          filled: true,
                                          fillColor: Constant.bgTextField,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Colors.transparent)
                                          ),
                                          hintText: 'Select City',
                                          hintStyle: const TextStyle(
                                              color: Constant.bgTextfieldHint
                                          )
                                      ),
                                      baseStyle: TextStyle(color: Constant.bgTextfieldHint),
                                    ),
                                    validator: (item) {
                                      if (item == null)
                                        return "Required field";
                                      else
                                        return null;
                                    },
                                  );
                                }
                                return Opacity(
                                  opacity: cityEnable ? 1.0 : 0.5,
                                  child: DropdownSearch(
                                    enabled: cityEnable,
                                    items: [],
                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                        dropdownSearchDecoration: InputDecoration(
                                            suffixIconColor: Constant.bgOrangeLite,
                                            filled: true,
                                            fillColor: Constant.bgTextField,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Colors.transparent)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Colors.transparent)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Colors.transparent)
                                            ),
                                            hintText: 'Select City',
                                            hintStyle: const TextStyle(
                                                color: Constant.bgTextfieldHint
                                            )
                                        )
                                    ),
                                  ),
                                );
                              },
                            ),
                            // SizedBox(
                            //   // color: Colors.red,
                            //   height: 60,
                            //   child: TextFormField(style: const TextStyle(color: Colors.white),
                            //     decoration: InputDecoration(
                            //         filled: true,
                            //         hintText: 'California',
                            //         hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                            //         fillColor: Constant.bgTextField,
                            //         // contentPadding: EdgeInsets.all(10),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //             borderSide: const BorderSide(color: Colors.transparent)
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //             borderSide: const BorderSide(color: Colors.transparent)
                            //         ),
                            //     ),
                            //   ),
                            // ),

                            const SizedBox(height: 15,),
                            const Text('Zip Code (Postal Code)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            TextFormField(
                              controller: zipController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Constant.bgTextfieldHint,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                filled: true,
                                hintText: 'Enter pin code',
                                hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                fillColor: Constant.bgTextField,
                                // contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.transparent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.transparent)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.transparent)
                                ),
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty || value.length < 6){
                                  return 'Enter Pin Code';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15,),
                            const Text('Mobile Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            SizedBox(
                              // color: Colors.red,
                              // height: 60,
                              child: /*Theme(
                                    data: ThemeData(
                                      inputDecorationTheme: const InputDecorationTheme(
                                        border: OutlineInputBorder(),
                                      ),

                                      primaryColor: Colors.green, // Sets the primary color
                                      hintColor: Colors.green, // Sets the accent color
                                    ),
                                    child: IntlPhoneField(
                                      decoration: InputDecoration(
                                          counter: SizedBox(),
                                          // labelText: 'Phone Number',counterText: '',
                                          //   suffixIcon: TextButton(
                                          //     onPressed: () {
                                          //       // Verify button action
                                          //     },
                                          //     child: const Text('Verify', style: TextStyle(color: Constant.bgOrange)),
                                          //   ),
                                          filled: true,
                                          fillColor: Constant.bgTextField,
                                          hintText: '123123',
                                          hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                          // border: OutlineInputBorder(
                                          //   borderSide: BorderSide(),
                                          // ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                              )
                                          )
                                      ),
                                      initialCountryCode: 'US', // Default country
                                      // style: TextStyle(color: Colors.red), // Change the color of the input text including the country code
                                      dropdownTextStyle: const TextStyle(color: Colors.white),
                                      onChanged: (phone) {
                                        if (kDebugMode) {
                                          print(phone.completeNumber);
                                        } // Output the complete phone number
                                      },
                                    ),
                                  ),*/

                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                cursorColor: Constant.bgTextfieldHint,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                    filled: true,
                                    hintText: 'Enter mobile number',
                                    hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                    fillColor: Constant.bgTextField,
                                    // contentPadding: EdgeInsets.all(10),
                                    prefixIcon: CountryCodePicker(
                                      onChanged: (country) {
                                        setState(() {
                                          _countryName = country.code!;
                                          _countryCode = country.dialCode!;
                                        });
                                      },
                                      initialSelection: _countryCode,
                                      showFlag: true,
                                      textStyle: TextStyle(color: Constant.bgTextfieldHint),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.transparent)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.transparent)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.transparent)
                                    )
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a phone number';
                                  }
                                  if (!Constant.validatePhoneNumber(value, _countryName)) {
                                    return 'Invalid phone number for country $_countryName';
                                  }
                                  return null; // Validation passed
                                },
                              ),
                            ),
                            // SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Save as primary address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                Switch(
                                  value: address,
                                  activeColor: Constant.bgOrange,
                                  onChanged: (value) {
                                    address = value;
                                    if(primeryAddress == 0){
                                      primeryAddress = 1;
                                    }else{
                                      primeryAddress = 0;
                                    }
                                    setState(() {

                                    });
                                  },)
                              ],
                            ),
                            const SizedBox(height: 30,),
                            Btn('', height: 50, width: MediaQuery.of(context).size.width,
                                linearColor1: Constant.bgLinearColor1,
                                linearColor2: Constant.bgLinearColor2,
                                name: 'Save Address', callBack: (){
                                  if(_formKey.currentState!.validate()){
                                    FocusScope.of(context).unfocus();
                                    print('name: ${nameController.text} ');
                                    print('address: ${addressController.text} ');
                                    print('selectedCountry: ${selectedCountry.toString()} ');
                                    print('selectedState: ${selectedState.toString()} ');
                                    print('selectedCity: ${selectedCity.toString()} ');
                                    print('zip: ${zipController.text} ');
                                    print('_countryCode: ${_countryCode} ');
                                    print('phone: ${phoneController.text} ');
                                    print('primeryAddress: ${primeryAddress.toString()} ');
                                    context.read<AddShippingAddressBloc>().add(AddShippingAddressRefreshEvent('',
                                        nameController.text, addressController.text, selectedCountry.toString(),
                                        selectedState.toString(), selectedCity.toString(), zipController.text,
                                        _countryCode, phoneController.text,
                                        primeryAddress.toString(), context));
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if(state is CountryError){
                  return Center(
                    child: Text(state.error),
                  );
                }
                return SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
