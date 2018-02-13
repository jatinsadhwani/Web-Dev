import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) {
  ReactDOM.render(<Demo channel={channel}/>, root);
}

var arrr = [];

class Demo extends React.Component {
  constructor(props) {
    super(props);
    this.channel=props.channel;
    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp); });

    this.state = {
      possible : ["","","","","","","","","","","","","","","",""],
      score : 0
    };

    this.buttonClick=this.buttonClick.bind(this);
    this.render = this.render.bind(this);
    this.refresh = this.refresh.bind(this);

  }

  gotView(msg){
    console.log("Got View",msg);
    this.setState(msg.view);
  }
  refresh(){
    this.channel.push("refresh",{})
        .receive("ok",this.gotView.bind(this));
  }
  buttonClick(param){
    var x = param;
    this.channel.push("click",{bnumber: x})
        .receive("ok",this.gotView.bind(this));

    setTimeout(()=>{
      this.channel.push("interval",{bnumber: x})
          .receive("final",this.gotView.bind(this))
    },500);
}

  render(){
    return(
      <div className = "Container">
        <div className="row">
          <div className="col-sm-3">
            <Buttons root={this} number = "0" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "1" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "2" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "3" />
          </div>
        </div>

        <div className="row">
          <div className="col-sm-3">
            <Buttons root={this} number = "4"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "5"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "6"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "7"/>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-3">
            <Buttons root={this} number = "8"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "9"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "10"/>
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "11"/>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-3">
            <Buttons root={this} number = "12" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "13" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "14" />
          </div>
          <div className="col-sm-3">
            <Buttons root={this} number = "15" />
          </div>
        </div>

        <div className="row">
          <div className="col-sm-6">
            <p> Ticks - {this.state.score}</p>
            <Button className="resetButton" onClick={this.refresh}>Reset Game</Button>
          </div>
        </div>

      </div>
    );
  }
}


function Buttons(params){
  let root = params.root;
  var x = parseInt(params.number,10);
  return(<div className="col-sm-3">
    <Button className="normalButton" number = {params.number} onClick={() => root.buttonClick(x)}>{root.state.possible[x]}</Button>
  </div>);
}
