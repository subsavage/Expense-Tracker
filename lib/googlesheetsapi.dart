import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "expense-tracker-370507",
  "private_key_id": "c24bedbfcb74bf2a127efbce2428806c63b194bc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6XHfOT+7SJmPF\nnhizSXEnQnRv9SKWqoV1F+nWfXcwlMvIBBvyEkNm9KWyYFalexduYudpuw6gV2xg\nVs3W9dMvrXWAvGS/ZHo9q6H/9BNJdvf9TYcSTDlRtauKD0yOdF8x83puY2x5cDBV\nbJlGMIoJTMNrHqx0c2b8RDTneMGCm/6sT4yg1qplCeBkrUqtbqkEbt+NHbyPiOky\ngbfFsRImo1y9mZL3KTy6qAGUdJLXBbDDMLM6adetqRvbiAA2/AA6pmYSWrxBfiZC\nPnJsLQ18dU6RfGAX2F0HKoCALl2K3m2iaVFbxTKbefqrh9kZnPIwBRvPWp7/sqeE\n8HKpTwNvAgMBAAECggEAHjkl0udCt4EzWBbCMb1c5P2RjaCnSeEAwNMugLMbU90l\nyVvlPlZ46OcPQkT+eFrkm2nd1tdX0WgsMtmRC2YVqFtMvaKQAjwk2QCPRsfKIvVw\n1XsvxydmelpopfzCMS4tTBgNCH8GVhF8PTZeCzSPBmAVJzezxzT6BDp5i/qZA3nK\n/M6u989WOOCrYcbtHK7QkgI38YnQRGbOtlaR5kQxE20uny/rmnfjkvq5BCbLO1u9\nmabfToLYPZywODDDzjK6379DVee6Ez3DpC2aOIU/k4/yMW9BVSvoHPVOlstYTS9K\nj73naBl0g6+18d68NfhWl1/DfV4zPVksVrqeAPpusQKBgQDsMx1OXyDY+3qCxdjD\nx+G13yGv/vPEntmvMbUSVwRU1gDZljVBCtSImmyxXYusxJ6o7mqUXL/RLzRFgXYw\nT7Jwnzd7il+8J1vuTd9pGaa0160U0tLpTrOY7OfwIB9q3X9WEDZwgG2Fr8WnRCTa\nqnyidnfl8zHj9EADuNeefGMUPwKBgQDJ+8+/hwLI3l5bKji3Ub9bJ3NEZU69omcP\nxssG1z4jugFyZJ4xLkFD2fDpRe6cJdEMAz+1aEbIwxqN50yeXwHCIOQ51LSb54Il\nBjOAyXBjrgGwZWyE/5KXmDVmVJIkoZpl+5zds5FGW7xhJKCj+TYMN9nbHLSbyq6i\nTmeAL0WE0QKBgQDaBjyQ8QJTB56IQ7PY1BImXPati/rbjX2GV626ZhQbcwaJ0jsJ\n9MNF7LVT6vNY4I1LhfdfR1XP83Cej+fWpFoj1vPR12KTPQmAqOUGEKVu3H5pcEk7\nDmh9SoC1iBE4BYjamlCF/CYcdqlNwnr6VNCC7jOyUI/GyNimFuMA6fRS5QKBgA7E\nCNjwjsSOdQlnGcRVBo8sYCHU4h+82pntp3P1kkZcV7S8JFBmGEFUkmcLRLlHjnO5\nXRPu7pXIpY1QJmrBeUhuzSBpK1bmYr5AKM22bC/tTZROpdNHN7k7WFQFxLVG1xmz\nfjE66ljhZfEYE2JJWqkkABojjBSDiaa14p0dV5CxAoGAKSgojcMRtHnJR2E4em6a\nCzIiSFrHNGotitdwSM8WWfn1TBE6/LpGeC0UmhjfaY1U5XLsWFBD/DKqHOJJ3Lh+\n3Z+RDa0TD/0q6VKcen0V4yY9stLlpmobDAh0jB01llrKE2RUJQ1+lEvQhZ3TWtZs\nDekGcbSpFR0JB7EY+UHmhQU=\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker-sheets@expense-tracker-370507.iam.gserviceaccount.com",
  "client_id": "102785802049631688755",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker-sheets%40expense-tracker-370507.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1urb9CzA-XvCYfIAMrqJ8Osd3f79ixg_MpOCq0hJWJ64';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
