import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/models/insurance_record.dart';
import 'records_controller.dart';

class RecordFormPage extends StatefulWidget {
  const RecordFormPage({super.key, this.existing});

  final InsuranceRecord? existing;

  @override
  State<RecordFormPage> createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _type = TextEditingController();
  final _idNumber = TextEditingController();
  final _premium = TextEditingController();
  final _phone = TextEditingController();
  final _holder = TextEditingController();
  final _insured = TextEditingController();
  final _policyNumber = TextEditingController();
  DateTime? _insuranceDate;

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    if (item != null) {
      _name.text = item.name;
      _type.text = item.insuranceType;
      _idNumber.text = item.idNumber;
      _premium.text = item.premium.toString();
      _phone.text = item.phone;
      _holder.text = item.policyHolder;
      _insured.text = item.insuredPerson;
      _policyNumber.text = item.policyNumber;
      _insuranceDate = item.insuranceDate;
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _type,
      _idNumber,
      _premium,
      _phone,
      _holder,
      _insured,
      _policyNumber,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? '新建记录' : '编辑记录')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_name, '姓名 *'),
            _field(_type, '保险类型 *'),
            _field(_idNumber, '证件号码 *'),
            _field(_premium, '保险费用 *', keyboardType: TextInputType.number),
            _DateField(
              value: _insuranceDate,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  locale: const Locale('zh', 'CN'),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: _insuranceDate ?? DateTime.now(),
                );
                if (picked != null) setState(() => _insuranceDate = picked);
              },
            ),
            _field(_phone, '手机号码 *', keyboardType: TextInputType.phone),
            _field(_holder, '投保人'),
            _field(_insured, '受保人'),
            _field(_policyNumber, '保单号'),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('保存')),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        validator: (value) =>
            label.contains('*') && (value == null || value.trim().isEmpty)
                ? '请填写$label'
                : null,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _insuranceDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请完整填写必填信息')));
      return;
    }
    final controller = context.read<RecordsController>();
    final premium = double.tryParse(_premium.text.trim());
    if (premium == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入正确的保险费用')));
      return;
    }
    final record = InsuranceRecord(
      id: widget.existing?.id ?? controller.nextId(),
      name: _name.text.trim(),
      insuranceType: _type.text.trim(),
      idNumber: _idNumber.text.trim(),
      premium: premium,
      insuranceDate: _insuranceDate!,
      phone: _phone.text.trim(),
      policyHolder: _holder.text.trim(),
      insuredPerson: _insured.text.trim(),
      policyNumber: _policyNumber.text.trim(),
      createdAt: widget.existing?.createdAt,
    );
    await controller.upsert(record);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('保存成功')));
    Navigator.pop(context);
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onTap});

  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '保险日期 *',
          ),
          child: Text(
            value == null ? '请选择日期' : DateFormat('yyyy-MM-dd').format(value!),
          ),
        ),
      ),
    );
  }
}
