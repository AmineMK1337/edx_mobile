import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/admin/room_model.dart';
import '../../viewmodels/admin/room_viewmodel.dart';

class AddRoomView extends StatefulWidget {
  final AdminRoom? room;
  const AddRoomView({super.key, this.room});

  @override
  State<AddRoomView> createState() => _AddRoomViewState();
}

class _AddRoomViewState extends State<AddRoomView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _type = 'TD';
  String _status = 'Libre';
  bool _hasProjector = false;
  bool _hasComputers = false;
  bool _hasAirConditioning = false;
  
  List<Equipment> _equipment = [];

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _nameController.text = widget.room!.name;
      _capacityController.text = widget.room!.capacity.toString();
      _buildingController.text = widget.room!.building;
      _floorController.text = widget.room!.floor.toString();
      _descriptionController.text = widget.room!.description ?? '';
      _type = widget.room!.type;
      _status = _mapStatusToFrench(widget.room!.status);
      _hasProjector = widget.room!.hasProjector;
      _hasComputers = widget.room!.hasComputers;
      _hasAirConditioning = widget.room!.hasAirConditioning;
      _equipment = List.from(widget.room!.equipment);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.room != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nom de la salle', _nameController, Icons.meeting_room),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Capacité', _capacityController, Icons.people, keyboardType: TextInputType.number),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Étage', _floorController, Icons.stairs, keyboardType: TextInputType.number),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Bâtiment', _buildingController, Icons.business),
                      const SizedBox(height: 16),
                      _buildTypeDropdown(),
                      const SizedBox(height: 16),
                      _buildStatusDropdown(),
                      const SizedBox(height: 16),
                      _buildTextField('Description (optionnel)', _descriptionController, Icons.description),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryPink, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Ajouter une salle',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryPink),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _type,
            decoration: const InputDecoration(border: InputBorder.none),
            items: ['Amphi', 'TD', 'Labo']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _type = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Statut', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(border: InputBorder.none),
            items: ['Libre', 'Occupée', 'Maintenance']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _status = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectorSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam, color: AppColors.primaryPink),
              const SizedBox(width: 12),
              const Text('Vidéoprojecteur', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Switch(
            value: _hasProjector,
            onChanged: (value) {
              setState(() {
                _hasProjector = value;
              });
            },
            activeColor: AppColors.primaryPink,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Ajouter la salle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<AdminRoomViewModel>();
      
      final roomData = AdminRoom(
        id: widget.room?.id ?? '',
        name: _nameController.text,
        type: _type,
        capacity: int.parse(_capacityController.text),
        hasProjector: _hasProjector,
        hasComputers: _hasComputers,
        hasAirConditioning: _hasAirConditioning,
        floor: int.parse(_floorController.text),
        building: _buildingController.text,
        status: _mapStatusToEnglish(_status),
        equipment: _equipment,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        createdAt: widget.room?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = widget.room != null
          ? await viewModel.updateRoom(widget.room!.id, roomData)
          : await viewModel.addRoom(roomData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.room != null ? 'Salle modifiée avec succès' : 'Salle ajoutée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Une erreur est survenue'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _mapStatusToEnglish(String frenchStatus) {
    switch (frenchStatus) {
      case 'Libre':
        return 'available';
      case 'Occupée':
        return 'occupied';
      case 'Maintenance':
        return 'maintenance';
      default:
        return 'available';
    }
  }

  String _mapStatusToFrench(String englishStatus) {
    switch (englishStatus) {
      case 'available':
        return 'Libre';
      case 'occupied':
        return 'Occupée';
      case 'maintenance':
        return 'Maintenance';
      default:
        return 'Libre';
    }
  }
}
