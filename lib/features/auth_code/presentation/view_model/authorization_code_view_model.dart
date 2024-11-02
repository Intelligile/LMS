import 'package:flutter/material.dart';
import 'package:lms/features/auth_code/domain/entities/authorization_code.dart';
import 'package:lms/features/auth_code/domain/repositories/authorization_code_repository.dart';

class AuthorizationCodeViewModel with ChangeNotifier {
  final AuthorizationCodeRepository repository;

  List<AuthorizationCode> _authorizationCodes =
      <AuthorizationCode>[]; // Holds all codes
  List<AuthorizationCode> _filteredAuthorizationCodes =
      <AuthorizationCode>[]; // Holds search results

  bool isLoading = false;
  bool isSearching = false; // Tracks whether a search is active

  AuthorizationCodeViewModel(this.repository);

  // Return the appropriate list based on whether the user is searching
  List<AuthorizationCode> get authorizationCodes {
    debugPrint('Is searching: $isSearching');
    return isSearching ? _filteredAuthorizationCodes : _authorizationCodes;
  }

  // Search by licensee ID
  // Search by licensee ID (sets isSearching to true)
  void searchByLicenseeId(int licenseeId) async {
    // Reset states for a fresh search
    isLoading = true; // Set loading to true to indicate search is in progress
    isSearching = true; // Indicate that a search is being performed
    notifyListeners(); // Notify UI about the state change

    try {
      _filteredAuthorizationCodes =
          []; // Reset the filtered list before the search
      notifyListeners(); // Notify UI of the reset

      // Fetch the specific authorization code
      final result =
          await repository.getAuthorizationCodeByLicenseeId(licenseeId);

      if (result != null) {
        _filteredAuthorizationCodes = [result]; // Add result to filtered list
        debugPrint('Found code for Licensee ID: $licenseeId');
        notifyListeners(); // Notify UI that the search has finished
      } else {
        _filteredAuthorizationCodes = []; // No results
        debugPrint('No codes found for Licensee ID: $licenseeId');
      }
    } catch (e) {
      print('Error searching by Licensee ID: $e');
    } finally {
      isLoading = false; // Set loading to false once the operation is complete
      isSearching =
          true; // Set searching to false once the operation is complete
      notifyListeners(); // Notify UI that the search has finished
    }
  }

  void fetchAllAuthorizationCodes() async {
    isLoading = true; // Set loading to true
    isSearching = false; // Reset searching state
    notifyListeners(); // Notify UI about the state change

    try {
      _authorizationCodes = await repository.getAllAuthorizationCodes();
    } catch (e) {
      print('Error fetching codes: $e');
    } finally {
      isLoading = false; // Set loading to false once the operation is complete
      notifyListeners(); // Notify UI that fetching has finished
    }
  }

  // Reset search and show all codes
  void resetSearch() {
    isSearching = false;
    notifyListeners();
  }
  // Reset search and show all codes

  Future<void> generateAmountBasedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int licenseeId,
      int productId,
      double discount,
      int productLimit) async {
    try {
      await repository.generateAmountBasedCode(amount, periodMonths,
          totalCredit, licenseeId, productId, discount, productLimit);
      print("SUCCESS");
      notifyListeners();
    } catch (e) {
      print("Error generating amount-based code: $e");
    }
  }

  Future<void> generateProductBasedCode(
      int productLimit, int licenseeId, int productId, double discount) async {
    try {
      await repository.generateProductBasedCode(
          productLimit, licenseeId, productId, discount);
      notifyListeners();
    } catch (e) {
      print("Error generating product-based code: $e");
    }
  }

  Future<void> generateCombinedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int productLimit,
      int licenseeId,
      int productId,
      double discount) async {
    try {
      await repository.generateCombinedCode(amount, periodMonths, totalCredit,
          productLimit, licenseeId, productId, discount);
      notifyListeners();
    } catch (e) {
      print("Error generating combined code: $e");
    }
  }
}
