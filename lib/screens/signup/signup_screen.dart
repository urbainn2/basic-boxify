// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) async {
            if (state.status == SignupStatus.error) {
              logger.i(state.failure.message.toString());
              await showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }

            /// If the user entered a valid email and password, then the user is created in Firebase.
            /// If the user is created in Firebase, then the user is sent an email verification.
            else if (state.status == SignupStatus.success) {
              final authUser = context.read<AuthBloc>().state.user!;
              if (!authUser.emailVerified) {
                logger.i('authUser.email NOT Verified');
                try {
                  await authUser.sendEmailVerification();
                } catch (err) {
                  logger.i('unable to authUser.sendEmailVerification: $err');
                  logger.i('user: $authUser');
                  await showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(
                      content: 'unable to authUser.sendEmailVerification: $err',
                    ),
                  );
                  return;
                }
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'accountCreated'.translate(),
                    ),
                    content: Text(
                      'verifyEmail'.translate(),
                    ),
                  ),
                );
                // await GoRouter.of(context).push('/login');
                context.read<LoginCubit>().reset();
                GoRouter.of(context).push('/login');
              } else {}
            }
            // else  {
            //   // logger.i('navigating from signup screen to username screen because SignupStatus.success');
            // }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: Core.app.signInBoxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/mrn.png',
                                height: Core.app.smallRowImageSize,
                                // fit: BoxFit.cover
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'emailWarning'.translate(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'Email'),
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value!.contains('@')
                                    ? 'Please enter a valid email.'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'Password'),
                                obscureText: true,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value!.length < 6
                                    ? 'Must be at least 6 characters.'
                                    : null,
                              ),
                              const SizedBox(height: 28),
                              ElevatedButton(
                                onPressed: () async {
                                  _submitForm(
                                    context,
                                    state.status == SignupStatus.submitting,
                                  );
                                },
                                child: Text('signUp'.translate()),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                // onPressed: () =>
                                //     GoRouter.of(context).push(LoginRoute()),
                                onPressed: () {
                                  GoRouter.of(context).push('/login');
                                },
                                child: Text('backToLogin'.translate()),
                              ),
                              // Add the Google Sign-In button
                              // ElevatedButton.icon(
                              //   onPressed: () {
                              //     context.read<SignupCubit>().signUpWithGoogle();
                              //   },
                              //   icon: Image.asset('assets/images/google.png', height: 18),
                              //   label: const Text('Sign Up with Google'),
                              // ),
                              sizedBox12,
                              // googleSignInWebPlugin.renderButton( configuration: GSIButtonConfiguration(theme: GSIButtonTheme.filledBlue,), ),
                              const SizedBox(height: 16),
                              // ...
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      logger.i(
        'submit sign up form context.read<SignupCubit>().signUpWithCredentials()',
      );
      context.read<SignupCubit>().signUpWithCredentials();
    } else {
      logger.i('failed signUpWithCredentials ');
    }
  }
}
