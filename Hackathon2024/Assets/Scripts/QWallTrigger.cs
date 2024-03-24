using UnityEngine;
using UnityEngine.Events;

public class QWallTrigger : MonoBehaviour
{
    [SerializeField] UnityEvent onTriggerEffect;
    [SerializeField] UnityEvent onTriggerExit;
    [SerializeField] UnityEvent onCorrectAnswer;

    private bool playerInTrigger = false;
    private int correctAnswer = 3; // Set this to the correct answer number (1, 2, or 3)

    private void Update()
    {
        if (playerInTrigger)
        {
            if (Input.GetKeyDown(KeyCode.Alpha1) && correctAnswer == 1 ||
                Input.GetKeyDown(KeyCode.Alpha2) && correctAnswer == 2 ||
                Input.GetKeyDown(KeyCode.Alpha3) && correctAnswer == 3)
            {
                onCorrectAnswer.Invoke();
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) // Make sure the collider is the player
        {
            playerInTrigger = true;
            onTriggerEffect.Invoke();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player")) // Make sure the collider is the player
        {
            playerInTrigger = false;
            onTriggerExit.Invoke();
        }
    }
}
