// ignore_for_file: prefer_const_constructors_in_immutables

part of 'user_libraries_cubit.dart';

class UserLibrariesState extends Equatable {
  final String rackName;

  const UserLibrariesState({required this.rackName});
  // factory UserLibrariesState.initial() {
  //   return UserLibrariesState(rackName: '');
  // }
  @override
  List<Object?> get props => [];

  UserLibrariesState copyWith({String? rackName}) {
    return UserLibrariesState(rackName: rackName ?? this.rackName);
  }
}

class UserLibrariesInitial extends UserLibrariesState {
  UserLibrariesInitial({required super.rackName});
}

class UserLibrariesLoading extends UserLibrariesState {
  UserLibrariesLoading({required super.rackName});
}

class UserLibrariesError extends UserLibrariesState {
  final String errorMessage;

  UserLibrariesError(this.errorMessage, {required super.rackName});
}

class UserLibrariesSuccess extends UserLibrariesState {
  final String successMessage;

  UserLibrariesSuccess(this.successMessage, {required super.rackName});
}

class UserLibrariesFetchSuccess extends UserLibrariesState {
  final RackList rackListing;

  UserLibrariesFetchSuccess(this.rackListing, {required super.rackName});
}

class RackList {
  final List<Map<String, dynamic>> myRack;

  const RackList(this.myRack);
}
