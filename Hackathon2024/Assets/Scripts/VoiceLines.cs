using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoiceLines : MonoBehaviour
{

    public List<AudioSource> voiceLines, randVoiceLines;
    private int randNum;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(RandomLines());
    }

    private IEnumerator RandomLines()
    {
        while (true)
        {
            yield return new WaitForSeconds(15);
            randNum = UnityEngine.Random.Range(0, 19);
            randVoiceLines[randNum].Play();
        }
    }

}
