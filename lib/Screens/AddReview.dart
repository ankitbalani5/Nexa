//
// import 'dart:convert';
// import 'dart:io';
// import 'package:custom_rating_bar/custom_rating_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nexa/Constant.dart';
// import 'package:nexa/Widget/Btn.dart';
// import '../Widget/TextStyles.dart';
// import '../core/buttons.dart';
//
// class AddReview extends StatefulWidget {
//   String itemId;
//   AddReview(this.itemId, {super.key});
//
//   @override
//   State<AddReview> createState() => _AddReviewState();
// }
//
// class _AddReviewState extends State<AddReview> {
//   final desController = TextEditingController();
//   double rating = 3.0;
//   File? selectedFile;
//   final ImagePicker picker = ImagePicker();
//
//   // Function to select an image or video
//   Future<void> _pickFile(String path) async {
//     if(path == 'image'){
//       final XFile? pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxHeight: 1024,
//         maxWidth: 1024,
//         imageQuality: 80,
//       );
//       if (pickedFile != null) {
//         setState(() {
//           selectedFile = File(pickedFile.path);
//           print('selectedFile::::::: image $selectedFile');
//         });
//       }
//     }else{
//       final XFile? pickedVideo = await picker.pickVideo(
//         source: ImageSource.gallery,
//       );
//
//       // Decide whether to use image or video based on user action
//       // For simplicity, here we're only allowing one selection at a time
//        if (pickedVideo != null) {
//         setState(() {
//           selectedFile = File(pickedVideo.path);
//           print('selectedFile::::::: video $selectedFile');
//         });
//       }
//
//     }
//
//   }
//
//   Future<void> _showMediaSelectionDialog() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Center(child: Text('Select Media')),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _pickFile('image');
//                   },
//                   child: Icon(Icons.camera_alt_outlined, size: 50,)),
//               GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _pickFile('video');
//                   },
//                   child: Icon(Icons.video_collection_outlined, size: 50,)),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _submitReview() async {
//     var token = Constant.token;
//     final uri = Uri.parse('https://urlsdemo.online/nexa/api/product-review');
//     var request = http.MultipartRequest('POST', uri);
//
//     request.fields['product_id'] = widget.itemId;
//     request.fields['description'] = desController.text;
//     request.fields['rating'] = rating.toString()/*rating.toString()*/;
//     request.headers['Authorization'] = 'Bearer $token';
//
//     if (selectedFile != null) {
//       String key = selectedFile!.path.endsWith('.mp4') ? 'video[]' : 'images[]';
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           key,
//           selectedFile!.path,
//           contentType: selectedFile!.path.endsWith('.mp4')
//               ? MediaType('video', 'mp4')
//               : MediaType('image', 'jpeg'),
//         ),
//       );
//     }
//
//     try {
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Parse the response body if needed
//         var responseBody = json.decode(response.body);
//
//
//
//         // Show success message
//         Fluttertoast.showToast(
//           msg: responseBody['message'] ?? 'Review submitted successfully!',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Constant.bgOrangeLite,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//
//         desController.clear();
//         selectedFile = null;
//
//         debugPrint('Review submitted successfully!');
//       } else {
//         // Handle failure and show error message
//         var responseBody = json.decode(response.body);
//         Fluttertoast.showToast(
//           msg: responseBody['error'] ?? 'Failed to submit review.',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//         debugPrint('Failed to submit review: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle exceptions
//       Fluttertoast.showToast(
//         msg: 'Error submitting review: $e',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       debugPrint('Error submitting review: $e');
//     }
//
//
//     // try {
//     //   var response = await request.send();
//     //   if (response.statusCode == 200) {
//     //     Fluttertoast.showToast(msg: respo)
//     //     debugPrint('Review submitted successfully!');
//     //   } else {
//     //     debugPrint('Failed to submit review: ${response.statusCode}');
//     //   }
//     // } catch (e) {
//     //   debugPrint('Error submitting review: $e');
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 80,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.asset(
//               'assets/profile/back.png',
//               height: 30,
//               width: 30,
//             ),
//           ),
//         ),
//         title: const Text(
//           'Add Reviews',
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Text('How was your experience ?', style: TextStyles.font18w7(Colors.black)),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: desController,
//               maxLines: 8,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 hintText: 'Describe your experience..',
//                 hintStyle: TextStyle(color: Constant.bgGrey),
//                 filled: true,
//                 fillColor: Constant.bgGrey.withOpacity(.10),
//                 border: OutlineInputBorder(
//                   borderRadius: Buttons.commonBorderRadius(),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text('What is your rating?', style: TextStyles.font18w7(Colors.black)),
//             RatingBar(
//               filledIcon: Icons.star,
//               emptyIcon: Icons.star_border,
//               onRatingChanged: (value) {
//                 setState(() {
//                   rating = value;
//                 });
//               },
//               initialRating: rating,
//               maxRating: 5,
//               size: 50,
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         height: 160,
//         child: Column(
//           children: [
//             InkWell(
//               onTap: _showMediaSelectionDialog,
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Constant.bgOrangeLite, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt_outlined, color: Constant.bgOrangeLite),
//                       SizedBox(width: 5),
//                       Text(
//                         'Add photos/video',
//                         style: TextStyle(
//                           color: Constant.bgOrangeLite,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Btn(
//               '',
//               height: 50,
//               width: MediaQuery.of(context).size.width,
//               linearColor1: Constant.bgLinearColor1,
//               linearColor2: Constant.bgLinearColor2,
//               name: 'Submit Review',
//               callBack: _submitReview,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Widget/Btn.dart';
import '../Bloc/OrderListBloc/order_list_bloc.dart';
import '../Bloc/ProductReviewBloc/product_review_bloc.dart';
import '../Widget/TextStyles.dart';
import '../core/buttons.dart';

class AddReview extends StatefulWidget {
  final String itemId;
  final String path;
  AddReview(this.itemId, this.path ,{super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final desController = TextEditingController();
  double rating = 3.0;
  List<File> selectedFiles = [];
  final ImagePicker picker = ImagePicker();

  // Function to select images or videos
  Future<void> _pickFiles(String type) async {
    if (type == 'image') {
      // Allow multiple image selection
      final List<XFile>? pickedImages = await picker.pickMultiImage(
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (pickedImages != null && pickedImages.isNotEmpty) {
        setState(() {
          selectedFiles.addAll(pickedImages.map((xfile) => File(xfile.path)));
          print('Selected images: $selectedFiles');
        });
      }
    } else if (type == 'video') {
      // Allow single video selection
      final XFile? pickedVideo = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedVideo != null) {
        File videoFile = File(pickedVideo.path);
        int videoSizeInBytes = await videoFile.length();

        // Check if video size is less than or equal to 20MB
        if (videoSizeInBytes <= 20 * 1024 * 1024) {
          setState(() {
            selectedFiles.add(videoFile);
            print('Selected video: $videoFile');
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Video size should be less than or equal to 20 MB',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    }
  }

  // Dialog to choose between image and video
  Future<void> _showMediaSelectionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Select Media')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFiles('image');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 50),
                    SizedBox(height: 8),
                    Text('Image'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFiles('video');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_collection_outlined, size: 50),
                    SizedBox(height: 8),
                    Text('Video'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to submit the review
  Future<void> _submitReview() async {
    if(_formKey.currentState!.validate()){
      Constant.showDialogProgress(context);
      var token = Constant.token;
      final uri = Uri.parse('https://urlsdemo.online/nexa/api/product-review');
      var request = http.MultipartRequest('POST', uri);

      // Add fields to the request
      request.fields['product_id'] = widget.itemId;
      request.fields['description'] = desController.text;
      request.fields['rating'] = rating.toInt().toString(); // Send as integer string
      request.headers['Authorization'] = 'Bearer $token';

      // Attach selected files to the request
      for (var file in selectedFiles) {
        String key = file.path.endsWith('.mp4') ? 'video[]' : 'images[]';
        request.files.add(
          await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: file.path.endsWith('.mp4')
                ? MediaType('video', 'mp4')
                : MediaType('image', 'jpeg'),
          ),
        );
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseBody = json.decode(response.body);
          Navigator.pop(context);
          context.read<ProductReviewBloc>().add(ProductReviewLoadEvent(widget.itemId.toString()));
          Navigator.pop(context);
          // Show success message
          Fluttertoast.showToast(
            msg: responseBody['message'] ?? 'Review submitted successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Constant.bgOrangeLite,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Clear the form
          desController.clear();
          setState(() {
            selectedFiles.clear();
          });

          // toreview
          if(widget.path == 'order'){
            Navigator.pop(context);
          context.read<OrderListBloc>().add(OrderListLoadEvent(status: 'all'));
          }

          debugPrint('Review submitted successfully!');
        } else {
          Navigator.pop(context);
          // Handle failure and show error message
          var responseBody = json.decode(response.body);
          Fluttertoast.showToast(
            msg: responseBody['error'] ?? 'Failed to submit review.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          debugPrint('Failed to submit review: ${response.statusCode}');
        }
      } catch (e) {
        // Handle exceptions
        Fluttertoast.showToast(
          msg: 'Error submitting review: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        debugPrint('Error submitting review: $e');
      }
    }

  }

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/profile/back.png',
              height: 30,
              width: 30,
            ),
          ),
        ),
        title: const Text(
          'Add Reviews',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text('How was your experience ?', style: TextStyles.font18w7(Colors.black)),
              SizedBox(height: 10),
              TextFormField(
                controller: desController,
                maxLines: 8,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  hintText: 'Describe your experience..',
                  hintStyle: TextStyle(color: Constant.bgGrey),
                  filled: true,
                  fillColor: Constant.bgGrey.withOpacity(.10),
                  border: OutlineInputBorder(
                    borderRadius: Buttons.commonBorderRadius(),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please give description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('What is your rating?', style: TextStyles.font18w7(Colors.black)),
              RatingBar(
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                onRatingChanged: (value) {
                  setState(() {
                    rating = value;
                  });
                },
                initialRating: rating,
                maxRating: 5,
                size: 50,
              ),
              SizedBox(height: 20),
              // Display selected files
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedFiles.map((file) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: file.path.endsWith('.mp4')
                            ? Icon(Icons.videocam, size: 50, color: Colors.grey)
                            : Image.file(file, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFiles.remove(file);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 160,
        child: Column(
          children: [
            InkWell(
              onTap: _showMediaSelectionDialog,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Constant.bgOrangeLite, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: Constant.bgOrangeLite),
                      SizedBox(width: 5),
                      Text(
                        'Add photos/video',
                        style: TextStyle(
                          color: Constant.bgOrangeLite,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Btn(
              '',
              height: 50,
              width: MediaQuery.of(context).size.width,
              linearColor1: Constant.bgLinearColor1,
              linearColor2: Constant.bgLinearColor2,
              name: 'Submit Review',
              callBack: _submitReview,
            ),
          ],
        ),
      ),
    );
  }
}
