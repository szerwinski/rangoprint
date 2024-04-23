package br.com.rangosemfila.rangoprint

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.Spinner
import com.pax.dal.IDAL
import com.pax.dal.IPrinter
import com.pax.dal.entity.EFontTypeAscii
import com.pax.dal.entity.EFontTypeExtCode
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.pax.neptunelite.api.NeptuneLiteUser

/** RangoprintPlugin */
class RangoprintPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  
  private lateinit var dal: IDAL
  
  private lateinit var printer: IPrinter
  

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val ops = NeptuneLiteUser.getInstance()
    dal = ops.getDal(flutterPluginBinding.applicationContext)
    printer = dal.printer
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "rangoprint")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val text: String = call.argument("text") ?: ""
    if (call.method == "small") {
       PrintSmall(text)
    } else if (call.method == "normal") {
      PrintNormal(text)
    } else if (call.method == "bold") {
      PrintBold(text)
    } else if (call.method == "custom") {
      PrintCustom(text)
    } else if (call.method == "short_cut") {
      CutPapper()
    } else if (call.method == "bitmap"){
      val tbt = call.argument<ByteArray>("imagedata")!!
      val bitmap = BitmapFactory.decodeByteArray(tbt, 0, tbt.size)
      PrintBitMap(bitmap)
    } else {
      result.error("Unknown method", "O método especificado não é conhecido", null)
      return
    }
    return  result.success("true")
    
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
  
  private fun PrintSmall(text: String) {
    printer.init()
    printer.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16)
    printer.setGray(50)
    printer.step(0)
    printer.printStr(text, "utf-8")
    printer.start()
  }
  
  private fun PrintNormal(text: String) {
    printer.init()
    printer.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16)
    printer.setGray(200)
    printer.step(0)
    printer.printStr(text, "utf-8")
    printer.start()
  }
  
  private fun PrintBold(text: String) {
    printer.init()
    printer.fontSet(EFontTypeAscii.FONT_8_32, EFontTypeExtCode.FONT_32_32)
    printer.setGray(250)
    printer.step(0)
    printer.printStr(text, "utf-8")
    printer.start()
  }

  private fun PrintCustom(text: String) {
    printer.init()
    printer.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16)
    printer.setGray(150)
    printer.printStr(text, "utf-8")
    printer.start()
  }
  
  
  private fun PrintBitMap(bitmap: Bitmap) {
    printer.init()
    printer.setGray(200)
    printer.printBitmap(bitmap)
    printer.start()
  }
  
  
  private fun CutPapper() {
    printer.init()
    printer.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16)
    printer.setGray(1)
    printer.step(0)
    for( i in 1..5){
      printer.printStr("", null)
    }
    printer.cutPaper(1)
    for( i in 1..2){
      printer.printStr("", null)
    }
  }
}
