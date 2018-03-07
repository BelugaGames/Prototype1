using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour
{
    public GameObject player;
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
        SceneManager.LoadScene("ProgrammerFinish");
    }

    public void LoadWin()
    {
        SceneManager.LoadScene("Win Scene");
    }

    public void LoadTutorial()
    {
        SceneManager.LoadScene("Tutorial");
    }

    public void ToggleInvertY()
    {
        if (player.GetComponent<movementController>().invertY)
        {
            player.GetComponent<movementController>().invertY = false;
        }
        else
        {
            player.GetComponent<movementController>().invertY = true;
        }
    }

    public void QuitLevel()
    {
        Application.Quit();
    }
}