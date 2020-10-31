var startTimerButton = document.querySelector('#startButton');
var pauseTimerButton = document.querySelector('#stopButton');
var notificationSound = document.querySelector('#notify');
var startTime;
var updatedTime;
var difference;
var tInterval;
var running = 0;
var hours = 0;
var minutes = 0;
var seconds = 0;
var startHours = 0;
var startMinutes = 0;
var stopHours = 0;
var stopMinutes = 0;
var formatedTime = '';
var capturedMinutes = 0;
var capturedHours = 0;
var capturedSeconds = 0;
var sumMinutes = 0;

function startTimer() {
    if (!running) {
        startTime = new Date().getTime();
        startMinutes = new Date().getMinutes();
        startHours = new Date().getHours();
        tInterval = setInterval(getShowTime, 1000);
        startHours = startHours < 10 ? '0' + startHours : startHours;
        startMinutes = startMinutes < 10 ? '0' + startMinutes : startMinutes;
        formatedTime = startHours + ':' + startMinutes;
        running = 1;
        document.getElementById('startButton').disabled = true;
        document.getElementById('stopButton').disabled = false;
        document.getElementById('saveTime').disabled = true;
    }
}

function resetTimer() {
    stopMinutes = new Date().getMinutes();
    stopHours = new Date().getHours();
    stopHours = stopHours < 10 ? "0" + stopHours : stopHours;
    stopMinutes = stopMinutes < 10 ? "0" + stopMinutes : stopMinutes;
    formatedTime += '-' + stopHours + ':' + stopMinutes;
    appendNewRow();
    formatedTime = '';
    clearInterval(tInterval);
    difference = 0;
    running = 0;
    document.getElementById('stopButton').disabled = true;
    document.getElementById('startButton').disabled = false;
    document.getElementById('saveTime').disabled = false;
}

function getShowTime() {
    updatedTime = new Date().getTime();
    difference = updatedTime - startTime;
    hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
    seconds = Math.floor((difference % (1000 * 60)) / 1000);
    checkHours();
    hours = hours < 10 ? "0" + hours : hours;
    minutes = minutes < 10 ? "0" + minutes : minutes;
    seconds = seconds < 10 ? "0" + seconds : seconds;
    console.log(hours + ':' + minutes + ':' + seconds);
}

function checkHours() {
    capturedSeconds++;
    if (capturedSeconds === 60) {
        capturedSeconds = 0;
        capturedMinutes++;
        sumMinutes++;
        window.$vars = { durationInMins: sumMinutes };
    }
    if (capturedMinutes === 60) {
        capturedMinutes = 0;
        capturedHours++;
    }
    console.log('total in checkHours: ' + capturedHours + ':' + capturedMinutes + ':' + capturedSeconds + ', total minutes: ' + sumMinutes);
    if (capturedHours < 8 || (capturedHours === 8 && capturedMinutes === 0 && capturedSeconds === 0)) {
        let formatedHours = capturedHours < 10 ? '0' + capturedHours : capturedHours;
        let formatedMinutes = capturedMinutes < 10 ? '0' + capturedMinutes : capturedMinutes;
        document.getElementById("totalTime").innerHTML = formatedHours + ':' + formatedMinutes;
    }
    else if ((capturedHours >= 8 && capturedHours < 12) || (capturedHours === 12 && capturedMinutes === 0 && capturedSeconds === 0)) {
        if (capturedHours === 12 && capturedMinutes === 0 && capturedSeconds === 0) {
            notificationSound.play();
        }
        let formatedHours = capturedHours - 8;
        formatedHours = formatedHours < 10 ? '0' + formatedHours : formatedHours;
        formatedMinutes = capturedMinutes < 10 ? '0' + capturedMinutes : capturedMinutes;
        document.getElementById("overtime").innerHTML = formatedHours + ':' + formatedMinutes;
    }
    else {
        resetTimer();
        document.getElementById('stopButton').disabled = true;
        document.getElementById('startButton').disabled = true;
        document.getElementById('saveTime').disabled = true;
    }
}

function appendNewRow() {
    let tableReference = document.getElementById('timeTable').getElementsByTagName('tbody')[0];
    let newRow = tableReference.insertRow(tableReference.rows.length);
    newRow.classList.add("time-row");
    let timestampCell = newRow.insertCell(0);
    let capturedCell = newRow.insertCell(1);
    let timestamp = document.createTextNode(formatedTime);
    if (sumMinutes >= 720) {
    hours = hours < 10 ? "0" + hours : hours;
    minutes = minutes < 10 ? "0" + minutes : minutes;
    }
    let captured = document.createTextNode(hours + ':' + minutes);
    timestampCell.appendChild(timestamp);
    capturedCell.appendChild(captured);

    console.log('total minutes in appendNewRow: ' + capturedMinutes);
}

function editTime() {
    var finalTime = document.getElementById('EditTime').value;
    console.log('Final time: ' + finalTime);
    var time = finalTime.split(':');
    capturedHours = parseInt(time[0]);
    capturedMinutes = parseInt(time[1]);
    console.log('editTime: ' + capturedMinutes);
    sumMinutes = parseInt(time[0]) * 60;
    sumMinutes += parseInt(time[1]);
    if (sumMinutes >= 480) {
        document.getElementById('totalTime').innerHTML = '08:00';
        let hours = Math.floor(sumMinutes / 60);
        hours -= 8;
        hours = hours < 10 ? '0' + hours : hours;
        let minutes = Math.floor(sumMinutes % 60);
        minutes = minutes < 10 ? '0' + minutes : minutes;
        document.getElementById('overtime').innerHTML = hours + ':' + minutes;
    }
    else {
        document.getElementById('totalTime').innerHTML = finalTime;
    }
    window.$vars = { durationInMins: sumMinutes };
}