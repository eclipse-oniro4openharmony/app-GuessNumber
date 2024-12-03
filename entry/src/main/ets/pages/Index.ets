import { randomNumberGenerator } from '../utils/numberUtils'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct Index {
  controller: TextInputController = new TextInputController()
  @State text: string = ''
  @State guessTime: number = 0
  @State answer: number = 0
  @State answerText: string = ''
  @State isWin: boolean = false

  aboutToAppear(): void {
    this.answer = randomNumberGenerator()
  }

  build() {
    Row() {
      Column() {
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
              this.text = value
            })
            .inputStyle()
            .borderWidth(1)

          Row({ space: 20 }) {
            Button('Guess')
              .onClick(() => {
                if (this.text == '') {
                  promptAction.showToast({
                    message: 'Please enter number from 0 to 100'
                  })
                }
                else {
                  const res = parseInt(this.text)
                  if (res > this.answer) {
                    this.answerText = 'big'
                  }
                  else if (res < this.answer) {
                    this.answerText = 'small'
                  }
                  else {
                    this.isWin = true
                  }
                  this.guessTime++
                  this.text = ''
                }
              })
              .buttonlStyle(
                Color.Green,
                Color.White,
              )

            Button('Reset')
              .onClick(() => {
                this.text = ''
                this.guessTime = 0
                this.answer = randomNumberGenerator()
                this.isWin = false
              })
              .buttonlStyle(
                Color.Black,
                Color.White,
              )
          }

          // Text(`Guess number: ${this.guessTime}`)
          if (this.guessTime != 0) {
            if (this.isWin == false) {
              Text(`tried ${this.guessTime} ${this.guessTime == 1 ? `time` : `times`}, your number is ${this.answerText}`)
            }
            else {
              if (this.guessTime == 1) {
                Text(`Correct! You are lucky, try to buy a lottery ticket today.`)
              }
              else if (this.guessTime < 5) {
                Text(`You are extremely smart, only use ${this.answerText} times! `)
              }
              else if (this.guessTime < 10 && this.guessTime > 5) {
                Text(`Your intelligence luck is above average, used ${this.guessTime} times to get the answer!`)
              }
              else {
                Text(`Your IQ and luck need to be recharged. It took you ${this.guessTime} times to answer it!`)
              }
            }
          }
          // Text(`Random number: ${this.answer}`)
        }
      }
      .width('100%')
    }
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