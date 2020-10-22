import 'package:app_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:app_loja_virtual/common/custom_icon_button.dart';
import 'package:app_loja_virtual/common/empty_card.dart';
import 'package:app_loja_virtual/common/order/order_tile.dart';
import 'package:app_loja_virtual/models/admin_orders_manager.dart';
import 'package:app_loja_virtual/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key key}) : super(key: key);

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, adminOrdersManager, __) {
          final filteredOrders = adminOrdersManager.filteredOrders;

          return SlidingUpPanel(
            body: Column(
              children: <Widget>[
                if (adminOrdersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${adminOrdersManager.userFilter.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            adminOrdersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  const Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            order: filteredOrders[index],
                            showControls: true,
                          );
                        }),
                  ),
                const SizedBox(
                  height: 120,
                ),
              ],
            ),
            minHeight: 40,
            maxHeight: 240,
            controller: panelController,
            panel: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      if (panelController.isPanelClosed) {
                        panelController.open();
                      } else {
                        panelController.close();
                      }
                    },
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(s)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: adminOrdersManager.statusFilter.contains(s),
                        onChanged: (v) {
                          adminOrdersManager.setStatusFilter(
                            status: s,
                            enabled: v,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
