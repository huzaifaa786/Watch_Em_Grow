import 'package:flutter/material.dart';
import 'package:mipromo/ui/category/filter/category_filter_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryFilterView extends StatelessWidget {
  const CategoryFilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryFilterViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: "Filters".text.lg.make(),
            actions: [
              IconButton(
                icon: const Icon(Icons.done),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
            ],
          ),
          body: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.filters.length,
                  itemBuilder: (context, index) => model.filters[index].text
                      .color(
                        model.selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      )
                      .make()
                      .pSymmetric(h: 12, v: 20)
                      .click(() {
                    model.onDestinationSelected(index);
                  }).make(),
                ),
              ),
              const VerticalDivider(
                width: 0,
                thickness: 0.7,
              ),
              Expanded(flex: 2, child: page(model.selectedIndex, context)),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CategoryFilterViewModel(),
    );
  }

  Widget page(int index, BuildContext context) {
    switch (index) {
      case 0:
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: Constants.cities.length,
          itemBuilder: (context, index) => Constants.cities[index] == "London"
              ? ExpansionTile(
                  backgroundColor: Colors.grey[700],
                  title: Constants.cities[index].text.make(),
                  children: List.generate(
                    Constants.londonBoroughs.length,
                    (index) => ListTile(
                      title: Constants.londonBoroughs[index].text
                          .make()
                          .click(() {})
                          .make(),
                    ),
                  ),
                )
              : ListTile(
                  title: Constants.cities[index].text
                      .make()
                      .click(
                        () {},
                      )
                      .make(),
                ),
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Select Price Range".text.make().pOnly(left: 12, top: 16),
            "£10 - £300+".text.bold.make().pOnly(left: 12, top: 16),
            RangeSlider(
              values: const RangeValues(1, 20),
              labels: const RangeLabels("start", "end"),
              min: 1,
              max: 20,
              onChanged: (v) {},
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            CheckboxListTile(
              value: true,
              dense: true,
              onChanged: (v) {},
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star_border_outlined,
                    size: 10,
                  ),
                  " 5".text.make(),
                ],
              ),
            ),
            CheckboxListTile(
              value: true,
              dense: true,
              onChanged: (v) {},
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 10,
                  ),
                  " 4".text.make(),
                ],
              ),
            ),
            CheckboxListTile(
              value: true,
              dense: true,
              onChanged: (v) {},
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 10,
                  ),
                  " 3".text.make(),
                ],
              ),
            ),
            CheckboxListTile(
              value: true,
              dense: true,
              onChanged: (v) {},
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 10,
                  ),
                  " 2".text.make(),
                ],
              ),
            ),
            CheckboxListTile(
              value: true,
              dense: true,
              onChanged: (v) {},
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 10,
                  ),
                  " 1".text.make(),
                ],
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }
}
