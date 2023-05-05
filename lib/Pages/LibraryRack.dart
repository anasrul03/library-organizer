// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/user_libraries_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LibraryRackPage extends StatefulWidget {
  const LibraryRackPage({super.key});

  @override
  State<LibraryRackPage> createState() => _LibraryRackPageState();
}

class _LibraryRackPageState extends State<LibraryRackPage> {
  late UserLibrariesCubit cubit;
  final String assetName = './lib/assets/empty.svg';
  final TextStyle title = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 26, color: Colors.indigo);
  final TextStyle subtitle = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Colors.grey);
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<UserLibrariesCubit>(context);
    cubit.fetchUserLibraries("myRack");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserLibrariesCubit(context.read<AuthRepo>().state),
      child: BlocBuilder<UserLibrariesCubit, UserLibrariesState>(
          bloc: cubit,
          builder: (BuildContext context, state) {
            if (state is UserLibrariesLoading) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.indigo,
                  size: 80,
                ),
              );
            } else if (state is UserLibrariesError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        assetName,
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Racks are not available on this version",
                        style: title,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: Text(
                          "Catch up with us and keep updated about our app, Racks will be available in future versions to sort your books :)",
                          style: subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserLibrariesFetchSuccess) {
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title:
                                      const Text("What is your new rack name?"),
                                  content: TextFormField(
                                    onChanged: (value) {
                                      context
                                          .read<UserLibrariesCubit>()
                                          .rackNameChanged(value);

                                      print(value);
                                    },
                                  ),
                                  actions: const [
                                    ElevatedButton(
                                        onPressed: null, child: Text("Add now"))
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.add))
                  ],
                  title: const Text("My Rack"),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 600,
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: state.rackListing.myRack.length,
                            itemBuilder: (context, index) {
                              final rack = state.rackListing.myRack[index];
                              final rackName = rack['RackName'];

                              return ListTile(
                                leading: const Icon(Icons.shelves),
                                title: Text(rackName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.grey)),
                          onPressed: () {
                            // context.read<UserLibrariesCubit>().addRack();
                          },
                          child: const Text(
                            "Add New Rack",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ))
                    ],
                  ),
                ),
              );
            } else if (state is UserLibrariesError) {
              print("error: ${state.errorMessage}");

              Navigator.pop(context,
                  'Sorry, item is not available currently ${state.errorMessage}');
              return const Text('');
            } else {
              return const Center(child: Text("Error caught! Try again"));
            }
          }),
    );
  }
}
