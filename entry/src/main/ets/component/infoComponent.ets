@Preview
@CustomDialog
export struct infoComponent {
  controller?: CustomDialogController

  build() {
    Column({ space: 20 }) {
      Text($r('app.string.rules_title'))
        .fontSize(27)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0F0026')
        .width('100%')

      Scroll() {
        Column({ space: 16 }) {
          Text($r('app.string.rules_intro'))
            .ruleTextStyle()
          Text($r('app.string.rules_step_1'))
            .ruleTextStyle()
          Text($r('app.string.rules_step_2'))
            .ruleTextStyle()
          Text($r('app.string.rules_step_3'))
            .ruleTextStyle()
          Text($r('app.string.rules_step_4'))
            .ruleTextStyle()
          Text($r('app.string.rules_reset'))
            .ruleTextStyle()
        }
        .width('100%')
      }
      .layoutWeight(1)

      Button($r('app.string.close_button'))
        .width('100%')
        .height(52)
        .fontColor('#FFFFFF')
        .backgroundColor('#6024B5')
        .type(ButtonType.Normal)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .borderRadius(16)
        .onClick(() => {
          this.controller?.close()
        })
    }
    .width('90%')
    .height('68%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(28)
  }
}

@Extend(Text)
function ruleTextStyle() {
  .fontSize(16)
  .fontColor('#0F0026')
  .width('100%')
}
