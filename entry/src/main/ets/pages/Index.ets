import { randomNumberGenerator } from '../utils/numberUtils'
import { infoComponent } from '../component/infoComponent'
import { KeyboardAvoidMode } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State text: string = ''
  @State guessTime: number = 0
  @State answer: number = 0
  @State isWin: boolean = false
  @State isInputInvalid: boolean = false
  @State lastGuessWasHigh: boolean = false

  infoController: CustomDialogController = new CustomDialogController({
    builder: infoComponent(),
    customStyle: true
  })
  successController: CustomDialogController = new CustomDialogController({
    builder: successComponent({
      guessTime: this.guessTime,
      isWin: this.isWin,
      text: this.text,
      answer: this.answer
    }),
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  aboutToAppear(): void {
    this.answer = randomNumberGenerator()
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }

  resetNumber(): void {
    this.text = ''
    this.guessTime = 0
    this.answer = randomNumberGenerator()
    this.isWin = false
    this.isInputInvalid = false
  }

  submitNumber(): void {
    const guessText = this.text.trim()
    if (!/^(?:[1-9]|[1-9][0-9]|100)$/.test(guessText)) {
      this.isInputInvalid = true
      return
    }

    this.isInputInvalid = false
    const guess = Number(guessText)
    this.guessTime++
    if (guess === this.answer) {
      this.isWin = true
      this.text = ''
      this.successController.open()
    } else {
      this.lastGuessWasHigh = guess > this.answer
    }
  }

  build() {
    Scroll() {
      Column({ space: 24 }) {
        Row() {
          Text($r('app.string.game_title'))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0F0026')
            .layoutWeight(1)

          Image($r('app.media.info_icon'))
            .width(44)
            .height(44)
            .onClick(() => {
              this.infoController.open()
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Column({ space: 24 }) {
          Text('1–100')
            .fontSize(52)
            .fontWeight(FontWeight.Bold)
            .fontColor('#6024B5')
            .width('100%')
            .textAlign(TextAlign.Center)

          Column({ space: 10 }) {
            TextInput({ text: this.text, placeholder: $r('app.string.guess_placeholder') })
              .width('100%')
              .height(60)
              .fontSize(17)
              .fontColor('#0F0026')
              .placeholderColor('#655A75')
              .caretColor('#6024B5')
              .backgroundColor('#F8F3FF')
              .border({ width: 1, color: this.isInputInvalid ? '#D61A8F' : '#DED2EF' })
              .borderRadius(16)
              .type(InputType.Number)
              .enterKeyType(EnterKeyType.Go)
              .onChange((value: string) => {
                this.text = value
                this.isInputInvalid = false
              })
              .onSubmit((_: EnterKeyType, event: SubmitEvent) => {
                this.submitNumber()
                if (!this.isWin) {
                  event.keepEditableState()
                }
              })

            if (this.isInputInvalid) {
              Text($r('app.string.invalid_guess'))
                .fontSize(14)
                .fontColor('#A00068')
                .width('100%')
            }
          }
          .width('100%')

          Row({ space: 12 }) {
            Button($r('app.string.guess_button'))
              .guessButtonStyle('#6024B5', '#FFFFFF')
              .layoutWeight(1)
              .onClick(() => {
                this.submitNumber()
              })

            Button($r('app.string.reset_button'))
              .guessButtonStyle('#F8F3FF', '#6024B5')
              .layoutWeight(1)
              .onClick(() => {
                this.resetNumber()
              })
          }
          .width('100%')
        }
        .width('100%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(28)

        if (this.guessTime > 0 && !this.isWin) {
          Row() {
            if (this.lastGuessWasHigh) {
              Text($r('app.string.guess_high', this.guessTime))
                .hintTextStyle()
            } else {
              Text($r('app.string.guess_low', this.guessTime))
                .hintTextStyle()
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#CCF6FB')
          .borderRadius(20)
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 32, bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F3FF')
  }
}

@Extend(Button)
function guessButtonStyle(buttonColor: ResourceColor, textColor: ResourceColor) {
  .fontColor(textColor)
  .backgroundColor(buttonColor)
  .height(54)
  .type(ButtonType.Normal)
  .fontSize(17)
  .borderWidth(0)
  .borderRadius(16)
  .fontWeight(FontWeight.Bold)
}

@Extend(Text)
function hintTextStyle() {
  .fontSize(18)
  .fontWeight(FontWeight.Medium)
  .fontColor('#0F0026')
  .width('100%')
}

@CustomDialog
struct successComponent {
  @Link guessTime: number
  @Link isWin: boolean
  @Link text: string
  @Link answer: number
  controller?: CustomDialogController

  aboutToDisappear(): void {
    if (this.isWin) {
      this.text = ''
      this.guessTime = 0
      this.answer = randomNumberGenerator()
      this.isWin = false
    }
  }

  build() {
    Column({ space: 20 }) {
      Row() {
        Text(this.guessTime <= 5 ? '★' : '✓')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor('#6024B5')
      }
      .width(64)
      .height(64)
      .backgroundColor(this.guessTime <= 5 ? '#FFEE4D' : '#F8F3FF')
      .borderRadius(32)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .alignSelf(ItemAlign.Center)

      if (this.guessTime === 1) {
        Text($r('app.string.win_first'))
          .successTextStyle(this.guessTime <= 5)
      } else if (this.guessTime < 5) {
        Text($r('app.string.win_quick', this.guessTime))
          .successTextStyle(this.guessTime <= 5)
      } else if (this.guessTime < 10) {
        Text($r('app.string.win_good', this.guessTime))
          .successTextStyle(this.guessTime <= 5)
      } else {
        Text($r('app.string.win_more', this.guessTime))
          .successTextStyle(this.guessTime <= 5)
      }

      Button($r('app.string.close_button'))
        .width('100%')
        .height(52)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.guessTime <= 5 ? '#6024B5' : '#FFFFFF')
        .backgroundColor(this.guessTime <= 5 ? '#FFEE4D' : '#6024B5')
        .type(ButtonType.Normal)
        .borderRadius(16)
        .onClick(() => {
          this.controller?.close()
        })
    }
    .padding(24)
    .width('86%')
    .backgroundColor(this.guessTime <= 5 ? '#6024B5' : '#FFFFFF')
    .borderRadius(24)
  }
}

@Extend(Text)
function successTextStyle(isFastWin: boolean) {
  .fontSize(22)
  .fontWeight(FontWeight.Bold)
  .fontColor(isFastWin ? '#FFFFFF' : '#0F0026')
  .width('100%')
  .textAlign(TextAlign.Center)
}
