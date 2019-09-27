using System;
using System.Collections;
using System.Data;
using System.Text;

using Constants = Globals.Constants;

namespace PasswordGeneration
    {

    // **************************************** class PasswordStrength
    
    /// <summary>
    /// Determines how strong a password is based on different 
    /// criteria; 0 is very weak and 100 is very strong
    /// 
    /// Concept from https://www.codeproject.com/script/Articles/
    /// ViewDownloads.aspx?aid=59186 which has been significantly 
    /// modified 
    /// </summary>
    public class PasswordStrength
        {
        
         enum Mode
            {
            NOT_SPECIFIED,
            SYMBOL,
            DIGIT,
            UPPERCASE,
            LOWERCASE
            }

        // ***************************************** password_strength

        /// <summary>
        /// determine the strength of the password
        /// </summary>
        /// <param name="password">
        /// string containing the password whose strength is to be 
        /// determined
        /// </param>
        /// <returns>
        /// integer containing the strength of the password; in the 
        /// range  [ 0 - 100 }
        /// </returns>
        public static int password_strength ( string password )
            {
            string      alphabetic_characters = 
                            "abcdefghijklmnopqrstuvwxyz";
            int         consecutive_digit_count = 0;
            int         consecutive_lowercase_count = 0;
            Mode        consecutive_mode = Mode.NOT_SPECIFIED;
            int         consecutive_symbol_count = 0;
            int         consecutive_uppercase_count = 0;
            int         digit_count = 0;
            int         iMiddle = 0;
            int         iMiddleEx = 1;
            int         lowercase_count = 0;
            string      numeric_characters = "01234567890";
            int         password_length = password.Length;
            Hashtable   repeated = new Hashtable();
            int         repeated_count = 1;
            int         requirments = 0;
            int         running_score = 0;
            int         sequential_alphabetic_count = 0;
            int         sequential_number_count = 0;
            string      strength_string = String.Empty;
            int         symbol_count = 0;
            int         uppercase_count = 0;
                                        // scan password
            foreach ( char ch in password.ToCharArray ( ) )
                {
                                        // count digits
                if ( Char.IsDigit ( ch ) )
                    {
                    digit_count++;

                    if ( consecutive_mode == Mode.DIGIT )
                        {
                        consecutive_digit_count++;
                        }
                    consecutive_mode = Mode.DIGIT;
                    }
                                        // count uppercase characters
                else if ( Char.IsUpper ( ch ) )
                    {
                    uppercase_count++;

                    if ( consecutive_mode == Mode.UPPERCASE )
                        {
                        consecutive_uppercase_count++;
                        }
                    consecutive_mode = Mode.UPPERCASE;
                    }
                                        // count lowercase characters
                else if ( Char.IsLower ( ch ) )
                    {
                    lowercase_count++;

                    if ( consecutive_mode == Mode.LOWERCASE )
                        {
                        consecutive_lowercase_count++;
                        }
                    consecutive_mode = Mode.LOWERCASE;
                    }
                                        // count symbols
                else if ( Char.IsSymbol ( ch ) || 
                     Char.IsPunctuation ( ch ) )
                    {
                    symbol_count++;
                    consecutive_mode = Mode.SYMBOL;
                    }
                                        // count repeated letters 
                if ( Char.IsLetter ( ch ) )
                    {
                    if ( repeated.Contains ( Char.ToLower ( ch ) ) ) 
                        {
                        repeated_count++;
                        }
                    else 
                        {
                        repeated.Add ( Char.ToLower ( ch), 0 );
                        }

                    if ( iMiddleEx > 1 )
                        {
                        iMiddle = iMiddleEx - 1;
                        }
                    }

                if ( ( uppercase_count > 0 ) || 
                     ( lowercase_count > 0 ) )
                    {
                    if ( Char.IsDigit ( ch ) || Char.IsSymbol ( ch ) )
                        {
                        iMiddleEx++;
                        }
                    }
                }         
                                        // check for sequential alpha 
                                        // string patterns (forward 
                                        // and reverse) 
            for ( int i = 0; ( i < 23 ); i++ )
                {
                string  forward = alphabetic_characters.
                                      Substring ( i, 3 );
                string  reverse = reverse_string ( forward );

                if ( ( password.ToLower ( ).
                                IndexOf ( forward ) != -1 ) || 
                     ( password.ToLower ( ).
                                IndexOf ( reverse ) != -1 ) )
                    {
                    sequential_alphabetic_count++;
                    }
                }
                                        // check for sequential 
                                        // numeric string patterns 
                                        // (forward and reverse)
            for ( int i = 0; ( i < 8 ); i++)
                {
                string  forward = numeric_characters.
                                      Substring ( i, 3 );
                string  reverse = reverse_string ( forward );

                if ( ( password.ToLower ( ).
                                IndexOf ( forward ) != -1 ) || 
                     ( password.ToLower ( ).
                                IndexOf ( reverse ) != -1 ) )
                    {
                    sequential_number_count++;
                    }
                }
                                        // ADDITIONS TO STRENGTH

                                        // running_score += 
                                        // 4 * password_length
            running_score = ( 4 * password_length );                      
                                        // if thee are uppercase 
                                        // letters running_score +=
                                        // 2 * number of uppercase 
                                        // letters
            running_score += ( 2 * ( password_length - 
                                     uppercase_count ) );
                                        // if there are lowercase 
                                        // letetrs running_score += 
                                        // 2 * number of lowercase 
                                        // letters
            running_score += ( 2 * ( password_length - 
                                     lowercase_count ) );;
                                        // if there are digits 
                                        // running_score += 
                                        // 4 * number of digits
            running_score += ( 4 * digit_count );
                                        // if there are symbols 
                                        // running_score += 
                                        // 6 * number of Symbols
            running_score += ( 6 * symbol_count );
                                        // if there are symbols in the 
                                        // middle of the password 
                                        // increment running_score by  
                                        // 2 * number of digits or 
                                        // symbols in middle of 
                                        // password
            running_score += ( 2 * iMiddle );
                                        // requirments
            requirments = 0;

            if ( password_length >= 
                 Constants.MINIMUM_PASSWORD_CHARACTERS ) 
                {
                requirments++;
                }
            if ( uppercase_count > 0 ) 
                {
                requirments++;
                }
            if ( lowercase_count > 0 )
                {
                requirments++;
                }
            if ( digit_count > 0 )
                {
                requirments++;
                }
            if ( symbol_count > 0 ) 
                {
                requirments++;
                }
                                        // if there are more than 3 
                                        // requirments then
            if ( requirments > 3)
                {
                                        // running_score += 
                                        // 2 * requirments 
                running_score += ( 2 * requirments );
                }

                                        // DEDUCTIONS FROM STRENGTH

                                        // If only letters decrement
                                        // running_score by length of
                                        // the password
            if ( ( digit_count == 0 ) && ( symbol_count == 0 ) )
                {
                running_score -= password_length;
                }
                                        // if only digits decrement
                                        // running_score by length of
                                        // the password
            if ( digit_count == password_length )
                {
                running_score -= password_length;
                }
                                        // if only repeated letters
                                        // decrement running_score by 
                                        // n * ( n - 1 ) where n is
                                        // the repeated count
            if ( repeated_count > 1 )
                {
                running_score -= ( repeated_count * 
                                   ( repeated_count - 1 ) );
                }
                                        // if consecutive uppercase 
                                        // letters decrement 
                                        // running_score by 2 * n
                                        // where n is the consecutive 
                                        // count
            running_score -= ( 2 * consecutive_uppercase_count );
                                        // if consecutive lowercase 
                                        // letters decrement 
                                        // running_score by 2 * n
                                        // where n is the consecutive 
                                        // count
            running_score -= ( 2 * consecutive_lowercase_count );
                                        // if consecutive symbols 
                                        // decrement running_score by 
                                        // 2 * n where n is the 
                                        // consecutive symbol count
            running_score -= ( 2 * consecutive_symbol_count );
                                        // if consecutive digits 
                                        // decrement running_score by 
                                        // 2 * n where n is the 
                                        // consecutive digit count
            running_score -= ( 2 * consecutive_digit_count );
                                        // if password contains a 
                                        // sequence of letters then 
                                        // decrement running_score by 
                                        // 3 * n where n is the 
                                        // letter sequence count
            running_score -= ( 3 * sequential_alphabetic_count );
                                        // if password contains a 
                                        // sequence of digits then 
                                        // decrement running_score by 
                                        // 3 * n where n is the 
                                        // digit sequence count
            running_score -= ( 3 * sequential_number_count );
                                        // determine complexity based 
                                        // on overall score
            if ( running_score > 100 )
                { 
                running_score = 100;
                } 
            else if ( running_score < 0 )
                { 
                running_score = 0;
                }

            return ( running_score );
            
            } // password_strength

        // ******************************************** reverse_string

        static string reverse_string ( string s)
            {
            StringBuilder  sb = new StringBuilder ( );

            for ( int i = ( s.Length - 1 ); ( i >= 0 ); i-- )
                {
                sb.Append ( s [ i ] );
                }

            return ( sb.ToString ( ) );

            } // reverse_string

        } // class PasswordStrength

    } // namespace PasswordGeneration