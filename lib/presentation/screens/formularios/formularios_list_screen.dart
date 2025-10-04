import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormulariosListScreen extends StatefulWidget {
  const FormulariosListScreen({Key? key}) : super(key: key);

  @override
  State<FormulariosListScreen> createState() => _FormulariosListScreenState();
}

class _FormulariosListScreenState extends State<FormulariosListScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'todos';
  final List<_FormularioItem> _formularios = [];

  @override
  void initState() {
    super.initState();
    _loadFormularios();
  }

  Future<void> _loadFormularios() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Load from API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      setState(() {
        _formularios.addAll([
          _FormularioItem(
            id: 1,
            cliente: 'Supermercado La Economía',
            tipo: 'Revisión de inventario',
            fecha: DateTime.now().subtract(const Duration(days: 1)),
            estado: 'completado',
          ),
          _FormularioItem(
            id: 2,
            cliente: 'Restaurante El Buen Sabor',
            tipo: 'Entrega de productos',
            fecha: DateTime.now().subtract(const Duration(hours: 3)),
            estado: 'pendiente',
          ),
          _FormularioItem(
            id: 3,
            cliente: 'Cafetería Central',
            tipo: 'Servicio técnico',
            fecha: DateTime.now().subtract(const Duration(days: 2)),
            estado: 'completado',
          ),
        ]);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar formularios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<_FormularioItem> get _filteredFormularios {
    if (_selectedFilter == 'todos') {
      return _formularios;
    }
    return _formularios.where((f) => f.estado == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formularios'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFormularios,
        child: _isLoading && _formularios.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _filteredFormularios.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFormularios.length,
                    itemBuilder: (context, index) {
                      final formulario = _filteredFormularios[index];
                      return _FormularioCard(
                        formulario: formulario,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/formularios/detalle',
                            arguments: formulario.id,
                          );
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/formularios/crear');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo formulario'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay formularios',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer formulario',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/formularios/crear');
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear formulario'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterOption(
              label: 'Todos',
              value: 'todos',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Completados',
              value: 'completado',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Pendientes',
              value: 'pendiente',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FormularioItem {
  final int id;
  final String cliente;
  final String tipo;
  final DateTime fecha;
  final String estado;

  _FormularioItem({
    required this.id,
    required this.cliente,
    required this.tipo,
    required this.fecha,
    required this.estado,
  });
}

class _FormularioCard extends StatelessWidget {
  final _FormularioItem formulario;
  final VoidCallback onTap;

  const _FormularioCard({
    required this.formulario,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (formulario.estado) {
      case 'completado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (formulario.estado) {
      case 'completado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description,
                      color: _getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formulario.cliente,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formulario.tipo,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 16,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formulario.estado.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(formulario.fecha),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
