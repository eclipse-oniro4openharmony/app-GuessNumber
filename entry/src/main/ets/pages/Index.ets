import { randomNumberGenerator } from '../utils/numberUtils'
import promptAction from '@ohos.promptAction'
import { infoComponent } from '../component/infoComponent'
import { KeyCode } from '@ohos.multimodalInput.keyCode';

@Entry
@Component
struct Index {
  controller: TextInputController = new TextInputController()
  @State text: string = ''
  @State guessTime: number = 0
  @State answer: number = 0
  @State answerText: string = ''
  @State isWin: boolean = false
  @State isRestart: boolean = false
  infoController: CustomDialogController = new CustomDialogController({
    builder: infoComponent(),
  })
  successController: CustomDialogController = new CustomDialogController({

    builder: successComponent({
      guessTime: this.guessTime,
      isWin: this.isWin,
      text: this.text,
      answer: this.answer,
    }),
    alignment: DialogAlignment.Center,
  })

  aboutToAppear(): void {
    this.answer = randomNumberGenerator()
  }

  resetNumber(): void {
    this.text = ''
    this.guessTime = 0
    this.answer = randomNumberGenerator()
    this.isWin = false
  }

  submitNumber() {
    if (this.text == '') {
      promptAction.showToast({
        message: 'Please enter number from 0 to 100'
      })
    }
    else if (this.text.length > 2) {
      promptAction.showToast({
        message: 'Invalid number!'
      })
    }
    else {
      const res = parseInt(this.text)
      if (res > this.answer) {
        this.answerText = 'big'
        this.guessTime++
      }
      else if (res < this.answer) {
        this.answerText = 'small'
        this.guessTime++
      }
      else {
        // Find the correct answer
        this.guessTime++
        this.isWin = true
        this.text = ''
        this.successController.open()
        this.isRestart = true
      }
    }
  }

  build() {
    Column() {
      Column() {
        Text('Guess a number')
          .fontSize(25)
          .fontWeight(FontWeight.Bolder)
      }.margin({
        bottom: 40
      })

      Column() {
        Image($r('app.media.info_icon'))
          .width(30)
          .alignSelf(ItemAlign.End)
          .margin({
            right: 20
          })
          .onClick(() => {
            this.infoController.open()
          })
        Column() {
          TextInput({ text: this.text, placeholder: 'input your number...', controller: this.controller })
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: 14, weight: 400 })
            .caretColor(Color.Blue)
            .width('95%')
            .height(40)
            .margin(20)
            .fontSize(14)
            .fontColor(Color.Black)
            .type(InputType.Number)
            .onChange((value: string) => {
              if (value.length > 2) {
                promptAction.showToast({
                  message: 'Please enter number in range 0-100!'
                })
              }
              this.text = value
            })
            .inputStyle()
            .borderWidth(1)
            .onKeyEvent((event?: KeyEvent) => {
              if (event) {
                if (event.keyCode == KeyCode.KEYCODE_ENTER) {
                  this.submitNumber()
                }
              }
            })

          Row({ space: 20 }) {
            Button('Guess')
              .onClick(() => {
                this.submitNumber()
              })
              .buttonlStyle(
                Color.Green,
                Color.White,
              )

            Button('Reset')
              .onClick(() => {
                this.resetNumber()
              })
              .buttonlStyle(
                Color.Black,
                Color.White,
              )
          }

          if (this.guessTime != 0) {
            if (this.isWin == false) {
              Text(`tried ${this.guessTime} ${this.guessTime == 1 ? `time` : `times`}, your number is ${this.answerText}`)
            }

          }
          // Text(`Random number: ${this.answer}`)
        }
      }
      .width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
  }
}

@Extend(Button)
function buttonlStyle(
  btColor: ResourceColor,
  fontColor: ResourceColor,
) {
  .fontColor(fontColor)
  .backgroundColor(btColor)
  .height('5%')
  .type(ButtonType.Normal)
  .fontSize(14)
  .borderWidth(0)
  .borderRadius(5)
  .fontWeight(FontWeight.Medium)
}

@Extend(TextInput)
function inputStyle() {
  .height(40)
  .backgroundColor(Color.Transparent)
  .fontSize(14)
}

@CustomDialog
struct successComponent {
  @Link guessTime: number;
  @Link isWin: boolean;
  @Link text: string;
  @Link answer: number;
  controller: CustomDialogController = new CustomDialogController({
    builder: successComponent({
      guessTime: this.guessTime,
      isWin: this.isWin,
      text: this.text,
      answer: this.answer,
    })
  })

  aboutToDisappear(): void {
    if (this.isWin == true) {
      this.text = ''
      this.guessTime = 0
      this.answer = randomNumberGenerator()
      this.isWin = false
    }
  }

  build() {
    Column() {
      // Text(`you win with ${this.guessTime} times`)
      if (this.guessTime == 1) {
        Text(`Correct! You are lucky, try to buy a lottery ticket today.`)
      }
      else if (this.guessTime < 5) {
        Text(`You are extremely smart, only use ${this.guessTime} times! `)
      }
      else if (this.guessTime < 10 && this.guessTime > 5) {
        Text(`Your intelligence luck is above average, used ${this.guessTime} times to get the answer!`)
      }
      else {
        Text(`Your IQ and luck need to be recharged. It took you ${this.guessTime} times to answer it!`)
      }
    }
    .height('30%')
    .justifyContent(FlexAlign.Center)
  }
}

