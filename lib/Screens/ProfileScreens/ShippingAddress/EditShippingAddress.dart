import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart' as screen;

import '../../../Bloc/AddShippingAddressBloc/add_shipping_address_bloc.dart';
import '../../../Bloc/CityBloc/city_bloc.dart';
import '../../../Bloc/CountryBloc/country_bloc.dart';
import '../../../Bloc/StateBloc/state_bloc.dart';
import '../../../Constant.dart';
import '../../../Model/CityModel.dart';
import '../../../Model/CountryModel.dart';
import '../../../Model/StateModel.dart';
import '../../../Widget/Btn.dart';

class EditShippingAddress extends StatefulWidget {
  String addressId;
  String name;
  String address;
  String country;
  String state;
  String city;
  String zip;
  String countryCode;
  String phone;
  String primaryAddress;
  String countryId;
  String stateId;
  EditShippingAddress(this.addressId, this.name, this.address, this.country,
      this.state, this.city, this.zip, this.countryCode, this.phone,
      this.primaryAddress, this.countryId, this.stateId, {super.key});

  @override
  State<EditShippingAddress> createState() => _EditShippingAddressState();
}

class _EditShippingAddressState extends State<EditShippingAddress> {
  var _formKey = GlobalKey<FormState>();
  bool address = false;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  var stateEnable = false;
  var cityEnable = false;
  late StateBloc _stateBloc;
  late CityBloc _cityBloc;
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var zipController = TextEditingController();
  var phoneController = TextEditingController();
  var primeryAddress ;
  String? _countryCode;
  String? _countryName;
  String? shortName;

  @override
  void initState() {

    _stateBloc = StateBloc();
    _cityBloc = CityBloc();
    context.read<CountryBloc>().add(CountryRefreshEvent());
    _stateBloc.add(SelectStateEvent(widget.countryId));
    _cityBloc.add(SelectCityEvent(widget.stateId));
    // context.read<CityBloc>().add(SelectCityEvent(widget.stateId));
    // context.read<StateBloc>().add(SelectStateEvent(widget.countryId));
    nameController.text = widget.name;
    addressController.text = widget.address;
    zipController.text = widget.zip;
    phoneController.text = widget.phone;
    _countryCode = widget.countryCode;
    // _countryName = widget.c
    selectedCountry = widget.country;
    selectedState = widget.state;
    selectedCity = widget.city;
    primeryAddress = widget.primaryAddress;
    if(widget.primaryAddress == '1'){
      address = true;
    }
    _countryName = Constant.getCountryCodeFromName(widget.country);
    shortName = Constant.getCountryCode(widget.countryCode);
    super.initState();
  }

  @override
  void dispose() {
    _stateBloc.close();
    _cityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/profile/back.png', height: 30, width: 30,),
          ),
        ),
        title: const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen.ShippingAddress()));
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
                                      return 'Enter first name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15,),
                                const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
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
                                        selectedCountry = value?.name;
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
                                            hintText: 'United States',
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

                                                    hintText: 'United States',
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
                                //               selectedCountry = value?.name;
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
                                //                   hintText: 'United States',
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
                                //                           hintText: 'United States',
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
                                                hintText: 'United States',
                                                hintStyle: const TextStyle(
                                                    color: Constant.bgTextfieldHint
                                                )
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 15,),
                                const Text('Zip Code (Postal Code)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6)
                                  ],
                                  style: const TextStyle(color: Colors.white),
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
                                    if(value == null || value.isEmpty){
                                      return 'Enter Pin Code';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15,),
                                const Text('Mobile Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                SizedBox(
                                  child:
                                  TextFormField(
                                    keyboardType: TextInputType.number,
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
                                      if (!Constant.validatePhoneNumber(value, _countryCode!)) {
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
                                return 'Enter first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          TextFormField(
                            controller: addressController,
                            style: const TextStyle(color: Colors.white),
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
                                selectedItem: _getSelectedCountry(selectedCountry, state.countryModel!.country),
                                items: state.countryModel!.country!,
                                itemAsString: (item) => item!.name.toString(),
                                onChanged: (value) async {
                                  selectedCountry = value!.name;
                                  _getSelectedCountry(selectedCountry, state.countryModel!.country);
                                  StateModel? stateDate = await Api.stateApi(value.id.toString());
                                  final cityId = stateDate!.states![0].id.toString();
                                  // stateEnable = false;
                                  cityEnable = false;
                                  selectedCountry = value!.name;
                                  // selectedCity!.name = '';
                                  print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                                  // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                                  // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                                  _stateBloc.add(SelectStateEvent(value!.id.toString()));


                                  _cityBloc.add(SelectCityEvent(cityId));
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
                                      hintText: 'United States',
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
                                    // _cityBloc.add(SelectCityEvent())
                                    return DropdownSearch<States?>(
                                      selectedItem: _getSelectedState(selectedState, state.stateModel!.states),
                                      items: state.stateModel!.states!,
                                      itemAsString: (item) => item!.name.toString(),
                                      onChanged: (value) {
                                        selectedState = value!.name;
                                        _getSelectedState(selectedState, state.stateModel!.states);
                                        cityEnable = false;
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
                                            hintText: 'United States',
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

                                              hintText: 'United States',
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
                          //             selectedItem: _getSelectedCountry(selectedCountry, state.countryModel!.country),
                          //             items: state.countryModel!.country!,
                          //             itemAsString: (item) => item!.name.toString(),
                          //             onChanged: (value) async {
                          //               selectedCountry = value!.name;
                          //               _getSelectedCountry(selectedCountry, state.countryModel!.country);
                          //               StateModel? stateDate = await Api.stateApi(value.id.toString());
                          //               final cityId = stateDate!.states![0].id.toString();
                          //               // stateEnable = false;
                          //               cityEnable = false;
                          //               selectedCountry = value!.name;
                          //               // selectedCity!.name = '';
                          //               print('selectedData:::::::${selectedCountry}--${selectedState}--${selectedCity}');
                          //               // BlocProvider.of<StateBloc>(context).add(SelectStateEvent(value!.id.toString()));
                          //               // BlocProvider.of<CityBloc>(context).add(SelectCityEvent(''));
                          //               _stateBloc.add(SelectStateEvent(value!.id.toString()));
                          //
                          //
                          //               _cityBloc.add(SelectCityEvent(cityId));
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
                          //                   hintText: 'United States',
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
                          //
                          //               if(state is StateSuccess){
                          //                 // _cityBloc.add(SelectCityEvent())
                          //                 return DropdownSearch<States?>(
                          //                   selectedItem: _getSelectedState(selectedState, state.stateModel!.states),
                          //                   items: state.stateModel!.states!,
                          //                   itemAsString: (item) => item!.name.toString(),
                          //                   onChanged: (value) {
                          //                     selectedState = value!.name;
                          //                     _getSelectedState(selectedState, state.stateModel!.states);
                          //                     cityEnable = false;
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
                          //                         hintText: 'United States',
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
                          //                           hintText: 'United States',
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
                                print('city Bloc success');
                                return DropdownSearch<Cities?>(
                                  selectedItem: _getSelectedCity(selectedCity, state.cityModel!.cities),
                                  items: state.cityModel!.cities!,
                                  itemAsString: (item) => item!.name.toString(),
                                  popupProps: const PopupProps.menu(
                                      showSearchBox: true
                                  ),
                                  onChanged: (value) {
                                    selectedCity = value!.name;
                                    _getSelectedCity(selectedCity, state.cityModel!.cities);
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
                                        hintText: 'United States',
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
                                          hintText: 'United States',
                                          hintStyle: const TextStyle(
                                              color: Constant.bgTextfieldHint
                                          )
                                      )
                                  ),
                                ),
                              );
                            },
                          ),

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
                            child:
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
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
                                if (!Constant.validatePhoneNumber(value, shortName!)) {
                                  return 'Invalid phone number for country $_countryName';
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
                                  print('name: ${nameController.text} ');
                                  print('address: ${addressController.text} ');
                                  print('selectedCountry: ${selectedCountry.toString()} ');
                                  print('selectedState: ${selectedState.toString()} ');
                                  print('selectedCity: ${selectedCity.toString()} ');
                                  print('zip: ${zipController.text} ');
                                  print('_countryCode: ${_countryCode} ');
                                  print('phone: ${phoneController.text} ');
                                  print('primeryAddress: ${primeryAddress.toString()} ');
                                  context.read<AddShippingAddressBloc>().add(AddShippingAddressRefreshEvent(widget.addressId.toString(),
                                      nameController.text, addressController.text, selectedCountry.toString(),
                                      selectedState.toString(), selectedCity.toString(), zipController.text,
                                      _countryCode!, phoneController.text,
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
    );
  }

  Country? _getSelectedCountry(String? countryName, List<Country>? countries) {
    if (countryName == null || countries == null) return null;
    return countries.firstWhere(
          (country) => country.name == countryName,
      orElse: () => Country(name: '', id: ''),
    );
  }

  States? _getSelectedState(String? stateName, List<States>? states) {
    if (stateName == null || states == null) return null;
    return states.firstWhere(
          (state) => state.name == stateName,
      orElse: () => States(name: states[0].name, id: ''),
    );
  }

  Cities? _getSelectedCity(String? cityName, List<Cities>? cities) {
    if (cityName == null || cities == null) return null;
    return cities.firstWhere(
          (city) => city.name == cityName,
      orElse: () => Cities(name: cities[0].name, id: ''),
    );
  }

}
