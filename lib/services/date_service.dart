class DateService {
  var ourDate = DateTime.now();

  setDate(DateTime date) async {
    ourDate = date;
  }
}
