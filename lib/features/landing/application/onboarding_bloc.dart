import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../domain/models/onboarding_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  
  PageController contentPageController = PageController();
  PageController imagePageController = PageController();
  String textDirection = 'rtl';
  int onBoardChangeIndex = 0;


  List<OnBoardingData> onBoardingData = onBoardingDataJson
      .map((item) => OnBoardingData.fromJson(item))
      .toList();

  OnBoardingBloc() : super(OnBoardingInitialState()) {
    on<GetOnBoardingDataEvent>(_onBoardingDataList);
    on<OnBoardingDataChangeEvent>(_onBoardChangeIndex);
    on<SkipEvent>(_onSkipEventCalled);
  }

  FutureOr<void> _onBoardingDataList(
      OnBoardingEvent event, Emitter<OnBoardingState> emit) async {
    emit(OnBoardingLoadingState());
    
    textDirection = await AppSharedPreference.getLanguageDirection();
    
    // final data = await serviceLocator<OnBoardingUsecase>().getOnboarding();

    // data.fold(
    //   (error) {
    //     emit(OnBoardingFailureState());
    //   },
    //   (success) {
    //     onBoardingData = success.data.onboarding.data;
    //     // log("success.data.onboarding.data:${success.data.onboarding.data}");
    //     emit(OnBoardingSuccessState());
    //   },
    // );
  }

  Future<void> _onBoardChangeIndex(
      OnBoardingDataChangeEvent event, Emitter<OnBoardingState> emit) async {
    onBoardChangeIndex = event.currentIndex;
    emit(OnBoardingDataChangeState());
  }

  Future<void> _onSkipEventCalled(
      SkipEvent event, Emitter<OnBoardingState> emit) async {
    await AppSharedPreference.setLandingStatus(true);
    emit(SkipState());
  }
}
