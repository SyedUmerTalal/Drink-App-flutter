import 'package:drink/blocs/home/search_dropdown/search_dropdown_bloc.dart';
import 'package:drink/blocs/home/update_circle/update_circle_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/prediction_tile.dart';
import 'package:drink/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    Key key,
    this.placesController,
    this.locationFocus,
    this.position,
    @required this.themeType,
  }) : super(key: key);
  final TextEditingController placesController;
  final FocusNode locationFocus;
  final Position position;
  final ThemeType themeType;
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  OverlayEntry overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void clearOnUnFocus() {
    context.read<SearchDropdownBloc>().add(ClearOverlay());
  }

  @override
  void initState() {
    super.initState();
    widget.locationFocus.addListener(clearOnUnFocus);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchDropdownBloc, SearchDropdownState>(
      listener: (context, state) {
        if (state.overlayVisibility ?? false) {
          _clearOverlay();
          if (state.isLoading) {
            _displayOverlay(_buildSearchingOverlay());
          } else if (state.isLoaded) {
            _displayOverlay(_buildPredictionOverlay(state.places.predictions));
          }
        } else if (state.isFailure) {
          if (state.message != 'success') {
            AppNavigation.showToast(message: state.message);
          }
        } else if (!(state.overlayVisibility ?? false)) {
          _clearOverlay();
        }

        if (state.selectedPlace != null) {
          context.read<UpdateCircleCubit>().updateCenter(
                LatLng(
                  state.selectedPlace.geometry.location.lat,
                  state.selectedPlace.geometry.location.lng,
                ),
              );
        }
      },
      child: CompositedTransformTarget(
        link: this._layerLink,
        child: TextFieldInput(
          focusNode: widget.locationFocus,
          textEditingController: widget.placesController,
          hintText: AppStrings.LOCATION,
          hintStyle: TextStyle(
            color: widget.themeType == ThemeType.light
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textStyle: TextStyle(
            color: widget.themeType == ThemeType.light
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          inputType: TextInputType.text,
          validator: (value) => null,
          inputAction: TextInputAction.done,
          formFieldSubmitted: (value) {
            widget.locationFocus.unfocus();
          },
        ),
      ),
    );
  }

  //------------------ DISPLAY OVERLAY---------------//
  void _displayOverlay(Widget overlayChild) {
    // final RenderBox appBarRenderBox = context.findRenderObject();
    // final screenWidth = MediaQuery.of(context).size.width;
    final RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        width: size.width,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            color: widget.themeType == ThemeType.light
                ? Colors.white
                : AppColors.GOLDEN,
            elevation: 4.0,
            child: overlayChild,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Widget _buildSearchingOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.CIRCLE_YELLOW),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Text(
              'Searching...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPredictionOverlay(List<Prediction> predictions) {
    return ListBody(
      children: predictions
          .map(
            (p) => PredictionTile(
              prediction: p,
              onTap: (selectedPrediction) {
                context.read<SearchDropdownBloc>().add(
                      PlaceSelected(selectedPrediction),
                    );

                widget.locationFocus.unfocus();
              },
            ),
          )
          .toList(),
    );
  }
}
