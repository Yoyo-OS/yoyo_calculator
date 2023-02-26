import 'package:fluent_ui/fluent_ui.dart';
import 'package:yoyo_calculator/model/historyitem.dart';
import 'package:hive/hive.dart';

class History extends StatelessWidget {
  History({Key? key}) : super(key: key);
  final List<HistoryItem> result = Hive.box<HistoryItem>('history')
      .values
      .toList()
      .reversed
      .toList()
      .cast<HistoryItem>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaffoldPage.scrollable(
          header: const PageHeader(
            title: Text('History'),
          ),
          children: [
            result.isEmpty
                ? const Center(
                    child: Text(
                      'Empty!',
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: result.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            result[i].title,
                          ),
                          subtitle: Text(result[i].subtitle),
                        ),
                      );
                    },
                  ),
          ]),
    );
  }
}
