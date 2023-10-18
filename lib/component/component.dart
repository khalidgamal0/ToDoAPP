import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../logic/to_do_cubit.dart';

Widget defaultTextFormField({
  @required TextEditingController? controller,
  @required String? labelText,
  @required IconData? prefixIcon,
  IconData? suffixIcon,
  @required TextInputType? type,
  bool obscureText = false,
  VoidCallback? onTap,
  Function()? suffixPressed,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  @required FormFieldValidator? validate,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon))
              : null,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon)),
      obscureText: obscureText,
      keyboardType: type,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validate,
    );

Widget itemTaskBuilder(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  ToDoCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  ToDoCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
            IconButton(
                onPressed: () {
                  ToDoCubit.get(context)
                      .updateData(status: 'task', id: model['id']);
                },
                icon: const Icon(
                  Icons.task,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
      onDismissed: (direction) {
        ToDoCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget conditionalBuild({@required List<Map>? task}) => ConditionalBuilder(
      condition: task!.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) =>
              itemTaskBuilder(task[index], context),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: task.length),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
