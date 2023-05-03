//    import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class NameViewList extends StatefulWidget {
// NameViewList({List<String> names}) : this.names = names ?? [];
//   final List<String> names;
//   @override
//   _NameViewListState createState() => _NameViewListState();
// }

// class _NameViewListState extends State<NameViewList> {


//   TextEditingController nameController = TextEditingController();

//    createDialog(BuildContext context){
//     return showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text('Insert Name'),
//         content: TextField(
//           controller: nameController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Contact Name',
//           ),
//         ),
//         actions: [
//           MaterialButton(
//             child: Text('Submit'),
//             onPressed: (){
//               addItemToList();
//               Navigator.of(context).pop();
//             },
//           )
//         ],
//       );
//     });
//   }

//   void addItemToList(){
//     setState(() {
//       widget.names.insert(0, nameController.text);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           IconButton(
//             icon: Icon(Icons.queue, color: Colors.green,),
//             onPressed: (){createDialog(context);},
//           ),
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Contact Name',
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               RaisedButton(
//                 child: Text('Clear'),
//                 onPressed: () {
//                   setState(() {
//                     widget.names.clear();

//                   });
//                 },
//               ),
//               RaisedButton(
//                 child: Text('Submit'),
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Basic(names: names)));
//                 },
//               ),
//             ],
//           ),