  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.3.1/firebase-app.js";
  import { getDatabase,ref,set,get,child } from "https://www.gstatic.com/firebasejs/10.3.1/firebase-database.js";

  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  const firebaseConfig = {
    apiKey: "AIzaSyA9RhHRDKJaJVAVtBwDqNIi2v2vsZyyuGs",
    authDomain: "airasia-online-check-in-system.firebaseapp.com",
    databaseURL: "https://airasia-online-check-in-system-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "airasia-online-check-in-system",
    storageBucket: "airasia-online-check-in-system.appspot.com",
    messagingSenderId: "975021124988",
    appId: "1:975021124988:web:de2f86dd530fe8012488f9"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);

  const db = getDatabase(app);

  document.getElementById("submit").addEventListener('click',function (e){
    e.preventDefault();
    set(ref(db, 'user/' + document.getElementById('yourName').value),
    {
        name: document.getElementById('yourName').value,
        email: document.getElementById('yourName').value,
        username: document.getElementById('yourUsername').value,
        password: document.getElementById('yourPassword').value,

    })
        alert("Registered!!!");
  })
