import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/client/models/cliente.dart';
import '../../modules/client/repositories/cliente_repository.dart';
import '../../modules/order/controllers/order_wizard_controller.dart';
import 'phone_input_formatter.dart';

class SearchableClientField extends StatefulWidget {
  const SearchableClientField({super.key, required this.controller});

  final OrderWizardController controller;

  @override
  State<SearchableClientField> createState() => _SearchableClientFieldState();
}

class _SearchableClientFieldState extends State<SearchableClientField> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateDialog(String nome) async {
    final telefoneController = TextEditingController();
    final enderecoController = TextEditingController();

    final created = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Novo cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: nome),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '99999-9999',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço (opcional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (created != true) return;

    if (!ClienteRepository.isValidTelefone(telefoneController.text)) {
      Get.snackbar('Atenção', 'Telefone inválido. Use o formato 99999-9999.');
      return;
    }

    await widget.controller.createCliente(
      nome: nome,
      telefone: telefoneController.text,
      endereco: enderecoController.text,
    );
    if (mounted) {
      setState(() => _searchController.text = nome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedNome = widget.controller.draft.value.clienteNome;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Cliente (opcional)'),
          const SizedBox(height: 8),
          if (selectedNome != null) ...[
            InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.controller.clearCliente();
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
              child: Text(selectedNome),
            ),
          ] else
            Autocomplete<Cliente>(
              displayStringForOption: (c) => c.nome,
              optionsBuilder: (textEditingValue) async {
                final query = textEditingValue.text;
                if (query.trim().isEmpty) return const Iterable<Cliente>.empty();
                final results =
                    await widget.controller.searchClientes(query);
                return results;
              },
              onSelected: (cliente) {
                widget.controller.selectCliente(cliente);
                _searchController.text = cliente.nome;
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                _searchController.value = controller.value;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Buscar cliente...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => onSubmitted(),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                final query = _searchController.text.trim();
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          ...options.map(
                            (c) => ListTile(
                              title: Text(c.nome),
                              subtitle: Text(c.telefone),
                              onTap: () => onSelected(c),
                            ),
                          ),
                          if (query.isNotEmpty)
                            ListTile(
                              leading: const Icon(Icons.person_add),
                              title: Text('Criar "$query"'),
                              onTap: () => _showCreateDialog(query),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}
