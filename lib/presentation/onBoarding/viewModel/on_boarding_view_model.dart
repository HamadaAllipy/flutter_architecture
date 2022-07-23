// Dart imports:
import 'dart:async';

// Project imports:
import 'package:flutter_architecture/domain/models/models.dart';
import 'package:flutter_architecture/presentation/base/base_view_model.dart';
import 'package:flutter_architecture/presentation/res/res.dart';

class OnBoardingViewModel extends BaseViewModel with InputOnBoardingViewModel, OutputOnBoardingViewModel{


  late List<SliderObject> _slider;

  final StreamController<SliderViewObject> _streamController = StreamController<SliderViewObject>();
  int _currentIndex = 0;


  void updateView(){
    inputSliderViewObject.add(SliderViewObject(
        _slider[_currentIndex],
        _currentIndex,
        _slider.length,
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _slider = _getSliders();
    updateView();
  }


  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    updateView();
  }

  @override
  int getNextIndex() {
    int index =  ++_currentIndex;
    if(index == _slider.length){
      index = 0;
    }
    return index;
  }



  @override
  int getPreviousIndex() {
    --_currentIndex;
    if(_currentIndex == -1){
      _currentIndex = _slider.length - 1;
    }
    return _currentIndex;
  }

  // private methods

  List<SliderObject> _getSliders() => [
        SliderObject(
          AppStrings.titleOnBoarding1,
          AppStrings.supTitleOnBoarding1,
          ImagesManager.imageOnBoarding1,
        ),
        SliderObject(
          AppStrings.titleOnBoarding2,
          AppStrings.supTitleOnBoarding2,
          ImagesManager.imageOnBoarding2,
        ),
        SliderObject(
          AppStrings.titleOnBoarding3,
          AppStrings.supTitleOnBoarding3,
          ImagesManager.imageOnBoarding3,
        ),
        SliderObject(
          AppStrings.titleOnBoarding4,
          AppStrings.supTitleOnBoarding4,
          ImagesManager.imageOnBoarding4,
        ),
      ];


  List<SliderObject> get slider=> _slider;

  @override
  Sink<SliderViewObject> get inputSliderViewObject => _streamController.sink;

  @override
  Stream<SliderViewObject> get outputSliderViewObject => _streamController.stream;


}

abstract class InputOnBoardingViewModel{

  void onPageChanged(int index);

  int getNextIndex();

  int getPreviousIndex();

  Sink<SliderViewObject> get inputSliderViewObject;


}
abstract class OutputOnBoardingViewModel{

  Stream<SliderViewObject> get outputSliderViewObject;
}
