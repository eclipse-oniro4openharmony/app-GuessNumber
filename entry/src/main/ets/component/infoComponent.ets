@Preview
@CustomDialog
export struct infoComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: infoComponent()
  })

  build() {
    Column() {
      Row() {
        Text('RULES')
          .fontSize(25)
      }
      .height('10%')

      Column() {
        Text('Number guessing game is a simple and classic online 1-100 number guessing small game: the system will randomly generate a number between 1 and 100, your task is to keep guessing to find this number.')
          .fontSize(18)
      }

      Column() {
        Text('Step 1: Enter your guessed number in the input box')
          .textStyle('10%')
        Text('Step 2: Click the "Guess" button to submit your guess')
          .textStyle('10%')
        Text('Step 3: Review the results and follow the prompts for your next guess')
          .textStyle('10%')
        Text('Step 4: After guessing the numbers right, you can learn how you\'re doing based on your evaluation')
          .textStyle('15%')
        Text('(You can also click the "Reset" button to start a new game)')
          .textStyle('10%')
      }
      Column(){
      Button('Close')
        .onClick(() => {
          this.controller.close()
        })
        .fontColor(Color.White)
        .backgroundColor(Color.Black)
        .type(ButtonType.Normal)
        .fontSize(14)
        .borderWidth(0)
        .borderRadius(5)
        .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height('10%')
      .justifyContent(FlexAlign.Center)
    }
    .width('90%')
    .height('100%')
  }
}

@Extend(Text)
function textStyle(height: string) {
  .width('100%')
  .height(height)
  .borderWidth(1)
}