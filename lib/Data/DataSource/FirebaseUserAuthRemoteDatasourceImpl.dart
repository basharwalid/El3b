import 'dart:async';
import 'package:El3b/Data/Error%20Handler/ErrorHandler.dart';
import 'package:El3b/Data/Firebase/FirebaseUserAuth.dart';
import 'package:El3b/Data/Models/User/UserDTO.dart';
import 'package:El3b/Domain/DataSource/FirebaseUserAuthRemoteDatasource.dart';
import 'package:El3b/Domain/Exception/FirebaseUserAuthException.dart';
import 'package:El3b/Domain/Exception/TimeOutOperationsException.dart';
import 'package:El3b/Domain/Exception/UnknownException.dart';
import 'package:firebase_auth/firebase_auth.dart';

// dependency injection
FirebaseUserAuthRemoteDatasource getFirebaseUserAuthRemoteDatasource() {
  return FirebaseUserAuthRemoteDatasourceImpl(
      firebaseUserAuth: injectFirebaseUserAuth(), errorHandler: injectErrorHandler());
}

// the object
class FirebaseUserAuthRemoteDatasourceImpl implements FirebaseUserAuthRemoteDatasource {

  FirebaseUserAuth firebaseUserAuth;
  ErrorHandler errorHandler;
  FirebaseUserAuthRemoteDatasourceImpl ({required this.firebaseUserAuth , required this.errorHandler});

  // function to create user account using firebase auth and handle any exceptions
  @override
  Future<void> createUser({required UserDTO user}) async{
    try{
      await firebaseUserAuth.createUser(user: user).timeout(const Duration(seconds: 60));
    }on FirebaseAuthException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleFirebaseAuthException(error: e.code));
    }on FirebaseException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleFirebaseAuthException(error: e.code));
    }on TimeoutException catch(e){
      throw TimeOutOperationsException(errorMessage: "User Auth Timed Out");
    }catch(e){
      throw UnknownException(errorMessage: "Unknown Error");
    }
  }

  // function to update user photo URL
  @override
  Future<User> updatePhotoUrl({required String photo}) async{
    try{
      var response = await firebaseUserAuth.updateUserPhoto(photo).timeout(const Duration(seconds: 60));
      return response;
    }on FirebaseAuthException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleFirebaseAuthException(error: e.code));
    }on FirebaseException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleFirebaseAuthException(error: e.code));
    }on TimeoutException catch(e){
      throw TimeOutOperationsException(errorMessage: "User Auth Timed Out");
    }catch(e){
      throw UnknownException(errorMessage: "Unknown Error");
    }
  }

  // function to sign in user using email and password to firebase auth
  @override
  Future<User> signInWithEmailAndPassword({required String email, required String password}) async{
    try{
      var response = await firebaseUserAuth.signInUserWithEmailAndPassword(email: email , password: password).timeout(const Duration(seconds: 60));
      return response;
    }on FirebaseAuthException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleLoginError( e.code));
    }on FirebaseException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleLoginError( e.code));
    }on TimeoutException catch(e){
      throw TimeOutOperationsException(errorMessage: "User Auth Timed Out");
    }catch(e){
      throw UnknownException(errorMessage: "Unknown Error");
    }
  }

  // function to reset User Password and handle any operation exception
  @override
  Future<void> resetPasswordWithEmail({required String email}) async{
    try{
      await firebaseUserAuth.resetPassword(email: email).timeout(const Duration(seconds: 60));
    }on FirebaseAuthException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleLoginError(e.code));
    }on TimeoutException catch(e){
      throw TimeOutOperationsException(errorMessage: "Operation Timed Out");
    }on FirebaseException catch(e){
      throw FirebaseUserAuthException(errorMessage: errorHandler.handleFirebaseAuthException(error: e.code));
    }catch (e){
      throw UnknownException(errorMessage: "Unknown Error");
    }
  }

}