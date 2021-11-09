import 'package:botapp/interfaces/filterable.dart';
import 'package:botapp/models/contact.dart';
import 'package:botapp/services/contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController implements Filterable {
  var contactList = List<Contact>.from([]).obs;
  var filterName = "".obs;
  var filteredContactList = List<Contact>.from([]).obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAllContacts({required String elderId}) async {
    isLoading(true);

    try {
      await ContactService.fetchAllContacts(elderId: elderId).then((res) {
        contactList.value = res;
        if (filterName.value == "")
          filteredContactList.value = res;
        else
          filterByName(name: filterName.value);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting All Contacts",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void createContact({
    required String name,
    required String number,
    required String countryCode,
    required String elderId,
  }) async {
    isLoading(true);
    try {
      await ContactService.createContact(
        name: name,
        number: number,
        countryCode: countryCode,
        elderId: elderId,
      ).then((res) {
        var contactName = res.name;
        Get.snackbar(
          "Successfully Created Contact",
          'Contact of $contactName has been created',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Creating Contact",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void deleteContact({required String id, required String elderId}) async {
    isLoading(true);

    try {
      await ContactService.deleteContact(id: id).then((res) {
        fetchAllContacts(elderId: elderId);
        Get.snackbar(
          "Success",
          "Successfully deleted contact",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting Contact",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void filterByName({required String name}) {
    if (name == "") filteredContactList.value = contactList;
    filteredContactList.value = contactList
        .where((contact) =>
            contact.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  void multiDeleteContact(
      {required List<String> id, required String elderId}) async {
    isLoading(true);

    try {
      await ContactService.multiDeleteContact(id: id).then((res) {
        fetchAllContacts(elderId: elderId);
        Get.snackbar(
          res,
          "Successfully deleted all contacts",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting All Contacts",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }
}
