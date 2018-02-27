using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void LoadMenu()
    {
        SceneManager.LoadScene("Main Menu");
    }

    public void LoadLevel()
    {
        SceneManager.LoadScene("Tutorial_Level");
    }

    public void LoadWin()
    {
        SceneManager.LoadScene("Win Scene");
    }

    public void LoadTutorial()
    {
        SceneManager.LoadScene("Tutorial");
    }

    public void QuitLevel()
    {
        Application.Quit();
    }
}